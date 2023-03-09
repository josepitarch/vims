import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io show Platform;

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 30,
        height: 30,
        child: io.Platform.isAndroid
            ? const CircularProgressIndicator()
            : const CupertinoActivityIndicator());
  }
}
