import 'package:logger/logger.dart';
import 'package:vims/models/actor_movie.dart';
import 'package:vims/providers/interface/infinite_scroll_provider.dart';
import 'package:vims/services/api/actor_filmography_service.dart';

final Logger logger = Logger();

class FilmographyProvider extends InfiniteScrollProvider<ActorMovie> {
  final int id;

  FilmographyProvider({required this.id, required int page})
      : super(page: page, limit: 20) {
    fetchData();
  }

  @override
  fetchData() {
    isLoading = true;
    getActorFilmography(id, page)
        .then((value) {
          data == null ? data = value.results : data!.addAll(value.results);
          total = value.total;
          limit = value.limit;
          hasNextPage = data!.length == limit;
        })
        .catchError((error) => exception = error)
        .whenComplete(() {
          isLoading = false;
          notifyListeners();
        });
  }

  @override
  fetchNextPage() {
    isLoading = true;
    notifyListeners();
    return super.fetchNextPage();
  }
}
