import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PullRefresh extends StatelessWidget {
  final bool isAndroid;
  final Widget child;
  final Future<void> Function() onRefresh;

  const PullRefresh(
      {required this.isAndroid,
      required this.child,
      required this.onRefresh,
      super.key});

  @override
  Widget build(BuildContext context) {
    return isAndroid
        ? _PullRefreshAndroid(onRefresh: onRefresh, child: child)
        : _PullRefreshIOS(onRefresh: onRefresh, child: child);
  }
}

class _PullRefreshAndroid extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  const _PullRefreshAndroid(
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

class _PullRefreshIOS extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  const _PullRefreshIOS(
      {Key? key, required this.child, required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: onRefresh,
          ),
          SliverToBoxAdapter(
            child: child,
          ),
        ],
      ),
    );
  }
}
