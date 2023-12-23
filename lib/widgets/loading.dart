import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: SizedBox(
          width: 30,
          height: 30,
          child: Theme.of(context).platform == TargetPlatform.android
              ? const CircularProgressIndicator()
              : const CupertinoActivityIndicator()),
    );
  }
}
