import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PullRefresh extends StatelessWidget {
  final List<Widget> children;
  final Future<void> Function() onRefresh;

  const PullRefresh(
      {required this.children, required this.onRefresh, super.key});

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.android
        ? _PullRefreshAndroid(onRefresh: onRefresh, children: children)
        : _PullRefreshIOS(onRefresh: onRefresh, children: children);
  }
}

class _PullRefreshAndroid extends StatelessWidget {
  final List<Widget> children;
  final Future<void> Function() onRefresh;
  const _PullRefreshAndroid({required this.children, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.orange.shade300,
        onRefresh: onRefresh,
        child: ListView(children: [...children, const SizedBox(height: 20)]),
      ),
    );
  }
}

class _PullRefreshIOS extends StatelessWidget {
  final List<Widget> children;
  final Future<void> Function() onRefresh;
  const _PullRefreshIOS({required this.children, required this.onRefresh});

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
              child: Column(
            children: [...children, const SizedBox(height: 20)],
          )),
        ],
      ),
    );
  }
}
