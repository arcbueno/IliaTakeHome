class NetworkErrorException implements Exception {
  final String message;

  NetworkErrorException(String errorMessage)
    : message =
          'A network error occurred. Please check your connection and try again. Error details: $errorMessage';

  @override
  String toString() => message;
}
