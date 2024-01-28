class MaintenanceException implements Exception {
  final String message;

  MaintenanceException(this.message);

  @override
  String toString() {
    return 'MaintenanceException: $message';
  }
}
