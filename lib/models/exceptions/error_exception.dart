class ErrorServerException implements Exception {
  final String message;

  ErrorServerException(this.message);

  @override
  String toString() {
    return 'ErrorServerException: $message';
  }
}
