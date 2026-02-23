import 'package:ilia_contacts/core/error/system_exception.dart';

class NetworkErrorException implements SystemException {
  @override
  final String message;

  NetworkErrorException(String errorMessage)
    : message =
          'A network error occurred. Please check your connection and try again. Error details: $errorMessage';

  @override
  String toString() => message;
}
