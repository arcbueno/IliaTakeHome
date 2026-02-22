import 'package:flutter/material.dart';
import 'package:ilia_contacts/core/repositories/contacts_repository.dart';
import 'package:ilia_contacts/features/contacts/contacts_list/contacts_list_state.dart';

class ContactsListViewmodel {
  final ContactsRepository _contactsRepository;

  final ValueNotifier<ContactsListState> state = ValueNotifier(
    ContactsListInitial(),
  );

  ContactsListViewmodel(this._contactsRepository) {
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    state.value = ContactsListLoading();
    final result = await _contactsRepository.fetchContacts();
    result.fold(
      onOk: (contacts) => state.value = ContactsListLoaded(contacts),
      onError: (error) => state.value = ContactsListError(error.toString()),
    );
  }
}
