import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vims/exceptions/maintenance_exception.dart';

class MaintenanceScreen extends StatefulWidget {
  final MaintenanceException error;
  const MaintenanceScreen(this.error, {super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(widget.error.message)),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemNavigator.pop();
  }
}
