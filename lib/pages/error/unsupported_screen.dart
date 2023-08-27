import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UnssuportedScreen extends StatelessWidget {
  const UnssuportedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String packageName = 'com.jopimi.vims';

    const String url = 'market://details?id=$packageName';
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
            'Esta versión ya no está soportada, por favor actualiza la aplicación.',
            textAlign: TextAlign.center),
        MaterialButton(
            color: Colors.orange,
            onPressed: () => launchUrlString(url),
            child: const Text('Actualizar'))
      ],
    ));
  }
}
