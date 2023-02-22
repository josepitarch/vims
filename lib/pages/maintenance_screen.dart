import 'package:flutter/material.dart';
import 'package:vims/exceptions/maintenance_exception.dart';

class MaintenanceScreen extends StatelessWidget {
  final MaintenanceException error;
  const MaintenanceScreen(this.error, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/icons/maintenance.png'),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
            child: Text(error.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6),
          ),
        ],
      ),
    );
  }
}
