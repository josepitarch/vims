import 'package:flutter/material.dart';

class SnackBarUtils {
  static void show(BuildContext context, String message) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(8),
      content: Text(message, style: Theme.of(context).textTheme.bodyText1),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
