class EmailExistsException implements Exception {
  String message = 'The email address is already in use by another account.';

  @override
  String toString() => message;
}
