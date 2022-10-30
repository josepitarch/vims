import 'package:flutter/material.dart';

class SnackbarApp extends SnackBar {
  SnackbarApp(
    String text, {
    Key? key,
  }) : super(
          key: key,
          content: Text(text),
          duration: const Duration(seconds: 2),
        );
}
