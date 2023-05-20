class UnsupportedException implements Exception {
  final String message;

  UnsupportedException(this.message);

  @override
  String toString() {
    return 'UnsupportedException: $message';
  }
}
