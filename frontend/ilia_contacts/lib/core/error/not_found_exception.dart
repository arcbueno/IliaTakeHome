import 'package:ilia_contacts/core/error/system_exception.dart';

class NotFoundException implements SystemException {
  @override
  String message = 'Contact not found.';

  @override
  String toString() => message;
}
