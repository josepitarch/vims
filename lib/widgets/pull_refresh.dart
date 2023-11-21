import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io' as io show Platform;

class PullRefresh extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const PullRefresh({required this.child, required this.onRefresh, super.key});

  @override
  Widget build(BuildContext context) {
    return io.Platform.isAndroid
        ? _PullRefreshAndroid(onRefresh: onRefresh, child: child)
        : _PullRefreshIOS(onRefresh: onRefresh, child: child);
  }
}

class _PullRefreshAndroid extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  const _PullRefreshAndroid({required this.child, required this.onRefresh});

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
  const _PullRefreshIOS({required this.child, required this.onRefresh});

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
