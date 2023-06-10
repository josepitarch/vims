import 'package:vims/providers/interface/base_providert.dart';

abstract class InfiniteScrollProvider<T> extends BaseProvider<List<T>> {
  int page;
  int? total;
  int limit;
  bool hasNextPage = false;
  double scrollPosition = 0;

  InfiniteScrollProvider({required this.page, required this.limit})
      : super(data: []);

  fetchNextPage() {
    if (hasNextPage) {
      page++;
      fetchData();
    }
  }

  resetPagination() {
    page = 1;
    total = null;
    hasNextPage = false;
    data = null;
    scrollPosition = 0;
  }
}
