import 'package:vims/providers/interface/base_providert.dart';

abstract class InfiniteScrollProvider<T> extends BaseProvider<List<T>> {
  int page;
  int? total;
  int limit;
  bool hasNextPage = false;
  double scrollPosition = 0;

  InfiniteScrollProvider({required this.page, required this.limit, super.data});

  fetchNextPage() {
    if (!isLoading && hasNextPage) {
      page++;
      fetchData();
    }
  }

  @override
  onRefresh() {
    page = 1;
    total = null;
    hasNextPage = false;
    scrollPosition = 0;
    super.onRefresh();
  }
}
