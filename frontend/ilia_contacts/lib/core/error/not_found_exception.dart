class NotFoundException implements Exception {
  String message = 'Contact not found.';

  @override
  String toString() => message;
}
