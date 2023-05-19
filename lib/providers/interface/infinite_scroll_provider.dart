import 'package:vims/models/paged_response.dart';
import 'package:vims/providers/interface/base_providert.dart';

abstract class InfiniteScrollProvider<T> extends BaseProvider {
  int page = 1;
  int? total;
  int? limit;
  bool? hasNextPage;

  InfiniteScrollProvider() : super(PagedResponse<T>.origin());
  fetchNextPage();
}
