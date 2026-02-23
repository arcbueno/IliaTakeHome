import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ilia_contacts/core/config/dependency_injection.dart';
import 'package:ilia_contacts/core/error/system_exception.dart';
import 'package:ilia_contacts/features/contacts/create_contact/create_contact_viewmodel.dart';
import 'package:ilia_contacts/features/contacts/widgets/create_contact_form.dart';

class CreateContactPage extends StatelessWidget {
  static const routeName = '/contacts/create';
  const CreateContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = CreateContactViewmodel(getIt.get());
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Contact')),
      body: ListenableBuilder(
        listenable: viewModel.createContactCommand,
        builder: (context, child) {
          if (viewModel.createContactCommand.running) {
            return Stack(
              children: [
                child!,
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
                    const SnackBar(
                      content: Text('Contact created successfully'),
                    ),
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
                      const SnackBar(
                        content: Text('An unexpected error occurred'),
                      ),
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
