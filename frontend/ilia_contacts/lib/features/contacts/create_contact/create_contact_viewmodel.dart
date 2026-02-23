import 'package:ilia_contacts/core/models/create_contact_dto.dart';
import 'package:ilia_contacts/core/repositories/contacts_repository.dart';
import 'package:ilia_contacts/core/utils/command.dart';
import 'package:ilia_contacts/core/utils/result.dart';

class CreateContactViewmodel {
  final ContactsRepository contactsRepository;

  CreateContactDto _contact = CreateContactDto.empty();

  late final Command0<void> createContactCommand = Command0(createContact);

  CreateContactViewmodel(this.contactsRepository);

  CreateContactDto get contact => _contact;

  set name(String value) {
    _contact = _contact.copyWith(name: value);
  }

  set email(String value) {
    _contact = _contact.copyWith(email: value);
  }

  set phone(String? value) {
    _contact = _contact.copyWith(phone: value);
  }

  Future<Result<void>> createContact() async {
    return contactsRepository.addContact(_contact);
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name is required';
    }
    return null;
  }
}
