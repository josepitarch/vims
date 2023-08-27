import 'package:flutter/material.dart';
import 'package:vims/widgets/loading.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Loading(),
    ));
  }
}
