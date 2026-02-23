import 'package:ilia_contacts/core/error/system_exception.dart';
import 'package:easy_localization/easy_localization.dart';

class NetworkErrorException implements SystemException {
  final String errorMessage;

  NetworkErrorException(this.errorMessage);

  @override
  String get message => 'network_error'.tr(args: [errorMessage]);

  @override
  String toString() => message;
}
