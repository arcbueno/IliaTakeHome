import 'package:ilia_contacts/core/error/system_exception.dart';
import 'package:easy_localization/easy_localization.dart';

class NotFoundException implements SystemException {
  @override
  String get message => 'contact_not_found_error'.tr();

  @override
  String toString() => message;
}
