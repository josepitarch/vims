import 'package:flutter/material.dart';

class SnackBarUtils {
  static void show(BuildContext context, String message) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(8),
      showCloseIcon: false,
      closeIconColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Text(message, style: Theme.of(context).textTheme.titleLarge),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
