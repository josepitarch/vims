import 'package:flutter/cupertino.dart';

class PullRefreshIOS extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  const PullRefreshIOS({Key? key, required this.child, required this.onRefresh})
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
