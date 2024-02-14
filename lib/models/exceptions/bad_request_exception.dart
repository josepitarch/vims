class BadRequestException implements Exception {
  final String message;

  BadRequestException(this.message);

  @override
  String toString() {
    return 'BadRequestException: $message';
  }
}
