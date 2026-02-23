import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ilia_contacts/core/config/dependency_injection.dart';
import 'package:ilia_contacts/features/contacts/contacts_list/contacts_list_viewmodel.dart';
import 'package:ilia_contacts/features/contacts/create_contact/create_contact_page.dart';
import 'package:ilia_contacts/features/contacts/widgets/contact_list_item.dart';
import 'package:ilia_contacts/features/contacts/widgets/empty_contacts_list_widget.dart';
import 'package:ilia_contacts/features/contacts/widgets/loading_list_component.dart';

class ContactsListPage extends StatefulWidget {
  static const routeName = '/contacts/list';
  const ContactsListPage({super.key});

  @override
  State<ContactsListPage> createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {
  late final ContactsListViewmodel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ContactsListViewmodel(getIt.get());
  }

  @override
  void dispose() {
    viewModel.state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('contacts_list_title'.tr())),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push(CreateContactPage.routeName);
          viewModel.fetchContacts();
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            viewModel.fetchContacts();
          },
          child: ValueListenableBuilder(
            valueListenable: viewModel.state,
            builder: (context, state, _) {
              return state.when(
                initial: () => Center(child: Text('initializing'.tr())),
                loading: () => LoadingListComponent(),
                loaded: (contacts) {
                  if (contacts.isEmpty) {
                    return const EmptyContactsListWidget();
                  }
                  return ListView.builder(
                    itemCount: contacts.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return ContactListItem(
                        key: ValueKey(contact.id),
                        contact: contact,
                        deleteContact: viewModel.deleteContact,
                      );
                    },
                  );
                },
                error: (message) =>
                    Center(child: Text('error_message'.tr(args: [message]))),
              );
            },
          ),
        ),
      ),
    );
  }
}
