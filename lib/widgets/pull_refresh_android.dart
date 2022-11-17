import 'package:flutter/material.dart';

class PullRefreshAndroid extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  const PullRefreshAndroid(
      {Key? key, required this.child, required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.orange.shade300,
        onRefresh: onRefresh,
        child: child,
      ),
    );
  }
}
