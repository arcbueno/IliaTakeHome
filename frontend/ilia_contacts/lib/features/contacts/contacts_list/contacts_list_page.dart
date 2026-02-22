import 'package:flutter/material.dart';
import 'package:ilia_contacts/core/config/dependency_injection.dart';
import 'package:ilia_contacts/features/contacts/contacts_list/contacts_list_viewmodel.dart';
import 'package:ilia_contacts/features/contacts/widgets/loading_list_component.dart';

class ContactsListPage extends StatelessWidget {
  static const routeName = '/contacts/list';
  const ContactsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the ViewModel with the repository from GetIt
    final viewModel = ContactsListViewmodel(getIt.get());

    return Scaffold(
      appBar: AppBar(title: const Text('Contacts List')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            viewModel.fetchContacts();
          },
          child: ValueListenableBuilder(
            valueListenable: viewModel.state,
            builder: (context, state, _) {
              return state.when(
                initial: () => const Center(child: Text('Initializing...')),
                loading: () => LoadingListComponent(),
                loaded: (contacts) => ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(contact.initials),
                      ), // Simple avatar
                      title: Text(contact.name),
                      subtitle: Text(contact.email),
                    );
                  },
                ),
                error: (message) => Center(child: Text('Error: $message')),
              );
            },
          ),
        ),
      ),
    );
  }
}
