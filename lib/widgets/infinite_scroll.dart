import 'package:flutter/cupertino.dart';
import 'package:vims/widgets/loading.dart';

class InfiniteScroll extends StatelessWidget {
  final Widget data;
  final bool isLoading;
  const InfiniteScroll(
      {required this.data, required this.isLoading, super.key});

  @override
  Widget build(BuildContext context) {
    final double left = MediaQuery.of(context).size.width * 0.5 - 20;
    return Expanded(
      child: Stack(
        children: [
          data,
          Positioned(
              bottom: 10,
              left: left,
              child: isLoading ? const Loading() : const SizedBox())
        ],
      ),
    );
  }
}
