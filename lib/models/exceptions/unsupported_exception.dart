class UnsupportedServerException implements Exception {
  final String message;

  UnsupportedServerException(this.message);

  @override
  String toString() {
    return 'UnsupportedException: $message';
  }
}
