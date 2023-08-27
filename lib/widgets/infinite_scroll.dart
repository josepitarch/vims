import 'package:flutter/cupertino.dart';
import 'package:vims/providers/interface/infinite_scroll_provider.dart';
import 'package:vims/widgets/loading.dart';

class InfiniteScroll extends StatefulWidget {
  final ScrollController scrollController;
  final InfiniteScrollProvider provider;
  final Widget data;

  const InfiniteScroll(
      {required this.provider,
      required this.scrollController,
      required this.data,
      super.key});

  @override
  State<InfiniteScroll> createState() => _InfiniteScrollState();
}

class _InfiniteScrollState extends State<InfiniteScroll> {
  @override
  void initState() {
    widget.scrollController.addListener(() {
      final double currentPosition = widget.scrollController.position.pixels;
      final double maxScroll = widget.scrollController.position.maxScrollExtent;
      widget.provider.scrollPosition = currentPosition;

      if (currentPosition + 300 >= maxScroll &&
          !widget.provider.isLoading &&
          widget.provider.hasNextPage) {
        widget.provider.fetchNextPage();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double left = MediaQuery.of(context).size.width * 0.5 - 20;
    return Stack(
      children: [
        widget.data,
        Positioned(
            bottom: 10,
            left: left,
            child:
                widget.provider.isLoading ? const Loading() : const SizedBox())
      ],
    );
  }
}
