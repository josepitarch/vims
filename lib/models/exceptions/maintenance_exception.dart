class MaintenanceException implements Exception {
  final String image;
  final String message;

  MaintenanceException(this.image, this.message);

  @override
  String toString() {
    return 'MaintenanceException: $message';
  }
}
