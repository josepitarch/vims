import 'package:vims/models/movie.dart';
import 'package:vims/providers/interface/base_providert.dart';
import 'package:vims/services/movie_service.dart';

class DetailsMovieProvider extends BaseProvider<Movie> {
  int? id;
  final Map<int, Movie> openedMovies = {};

  DetailsMovieProvider() : super();

  getDetailsMovie(int id) async {
    try {
      Movie? movie = await DetailsMovieService().getMovie(id);
      openedMovies[id] = movie!;
    } on Exception catch (e) {
      exception = e;
    } finally {
      this.id = id;
      isLoading = false;
      notifyListeners();
    }
  }

  onRefresh() async {
    if (id != null) {
      isLoading = true;
      exception = null;
      notifyListeners();
      getDetailsMovie(id!);
    }
  }

  clear() {
    id = null;
    exception = null;
    openedMovies.clear();
  }
}
