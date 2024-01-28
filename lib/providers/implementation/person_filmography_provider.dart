import 'package:logger/logger.dart';
import 'package:vims/models/actor_movie.dart';
import 'package:vims/providers/interface/infinite_scroll_provider.dart';
import 'package:vims/services/api/person_filmography.dart';

final Logger logger = Logger();

class FilmographyProvider extends InfiniteScrollProvider<ActorMovie> {
  final int id;

  FilmographyProvider({required this.id, required int page, data})
      : super(page: page, limit: 20, data: data) {
    if (page == 1) {
      fetchData();
    } else {
      hasNextPage = data?.length == limit;
    }
  }

  @override
  fetchData() {
    isLoading = true;
    getActorFilmography(id, page).then((value) {
      data == null ? data = value.results : data!.addAll(value.results);
      total = value.total;
      limit = value.limit;
      hasNextPage = value.results.length == limit;
    }).catchError((e) {
      exception = e;
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  @override
  fetchNextPage() {
    isLoading = true;
    notifyListeners();
    super.fetchNextPage();
  }

  @override
  onRefresh() {
    isLoading = true;
    notifyListeners();
    super.onRefresh();
  }
}
