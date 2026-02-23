import 'package:ilia_contacts/core/error/system_exception.dart';

class EmailExistsException implements SystemException {
  @override
  String message = 'The email address is already in use by another account.';

  @override
  String toString() => message;
}
