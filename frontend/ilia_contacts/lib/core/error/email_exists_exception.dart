import 'package:ilia_contacts/core/error/system_exception.dart';
import 'package:easy_localization/easy_localization.dart';

class EmailExistsException implements SystemException {
  @override
  String get message => 'email_exists_error'.tr();

  @override
  String toString() => message;
}
