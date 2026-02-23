import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ilia_contacts/core/config/dependency_injection.dart';
import 'package:ilia_contacts/core/error/system_exception.dart';
import 'package:ilia_contacts/features/contacts/create_contact/create_contact_viewmodel.dart';
import 'package:ilia_contacts/features/contacts/widgets/create_contact_form.dart';

class CreateContactPage extends StatefulWidget {
  static const routeName = '/contacts/create';
  const CreateContactPage({super.key});

  @override
  State<CreateContactPage> createState() => _CreateContactPageState();
}

class _CreateContactPageState extends State<CreateContactPage> {
  late final CreateContactViewmodel viewModel;
  late final GlobalKey<FormState> formKey;

  @override
  initState() {
    formKey = GlobalKey<FormState>();
    viewModel = CreateContactViewmodel(getIt());
    super.initState();
  }

  @override
  void dispose() {
    viewModel.createContactCommand.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('create_contact_title'.tr())),
      body: ListenableBuilder(
        listenable: viewModel.createContactCommand,
        builder: (context, child) {
          if (viewModel.createContactCommand.running) {
            return Stack(
              children: [
                IgnorePointer(child: child!),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            );
          }
          if (viewModel.createContactCommand.result != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              viewModel.createContactCommand.result!.fold(
                onOk: (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('contact_created_success'.tr())),
                  );
                  viewModel.createContactCommand.clearResult();
                  Navigator.of(context).pop(); // Go back to the contacts list
                },
                onError: (error) {
                  if (error is SystemException) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error.message)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('unexpected_error'.tr())),
                    );
                  }

                  viewModel.createContactCommand.clearResult();
                },
              );
            });
          }
          return child!;
        },
        child: CreateContactForm(
          onNameChanged: (String value) => viewModel.name = value,
          onEmailChanged: (String value) => viewModel.email = value,
          onPhoneChanged: (String? value) => viewModel.phone = value,
          onValidateName: viewModel.validateName,
          onValidateEmail: viewModel.validateEmail,
          onSubmit: () {
            FocusScope.of(
              context,
            ).requestFocus(FocusNode()); // Dismiss the keyboard
            if (formKey.currentState?.validate() ?? false) {
              viewModel.createContactCommand.execute();
            }
          },
          formKey: formKey,
        ),
      ),
    );
  }
}
