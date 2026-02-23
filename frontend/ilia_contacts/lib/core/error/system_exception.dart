abstract class SystemException implements Exception {
  final String message;

  SystemException(this.message);

  @override
  String toString() => 'SystemException: $message';
}
