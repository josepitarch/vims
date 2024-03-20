class ConnectivityException implements Exception {
  final String message;

  ConnectivityException(this.message);

  @override
  String toString() {
    return 'ConnectivityException: $message';
  }
}
