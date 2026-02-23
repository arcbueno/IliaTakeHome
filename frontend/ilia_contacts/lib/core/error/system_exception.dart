import 'package:easy_localization/easy_localization.dart';

abstract class SystemException implements Exception {
  String get message;

  @override
  String toString() => 'system_exception_prefix'.tr(args: [message]);
}
