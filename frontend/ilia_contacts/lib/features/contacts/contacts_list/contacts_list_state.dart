import 'package:ilia_contacts/core/models/contact_model.dart';

sealed class ContactsListState {
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(List<ContactModel> contacts) loaded,
    required T Function(String message) error,
  }) {
    return switch (this) {
      ContactsListInitial() => initial(),
      ContactsListLoading() => loading(),
      ContactsListLoaded(:final contacts) => loaded(contacts),
      ContactsListError(:final message) => error(message),
    };
  }
}

class ContactsListInitial extends ContactsListState {}

class ContactsListLoading extends ContactsListState {}

class ContactsListLoaded extends ContactsListState {
  final List<ContactModel> contacts;

  ContactsListLoaded(this.contacts);
}

class ContactsListError extends ContactsListState {
  final String message;

  ContactsListError(this.message);
}
