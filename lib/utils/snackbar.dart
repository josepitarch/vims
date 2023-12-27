import 'package:flutter/material.dart';

class SnackBarUtils {
  static void show(BuildContext context, String message) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(8),
      showCloseIcon: false,
      closeIconColor: Colors.white,
      content: Text(message),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
