import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:vims/models/movie.dart';
import 'package:vims/services/movie_service.dart';

class DetailsMovieProvider extends ChangeNotifier {
  int? id;
  bool isLoading = true;
  Exception? error;
  final Map<int, Movie> openedMovies = {};
  final logger = Logger();

  DetailsMovieProvider();

  getDetailsMovie(int id) async {
    try {
      Movie? movie = await DetailsMovieService().getMovie(id);
      openedMovies[id] = movie!;
    } on Exception catch (e) {
      error = e;
      logger.e(e.toString());
    } finally {
      this.id = id;
      isLoading = false;
      notifyListeners();
    }
  }

  onRefresh() async {
    if (id != null) {
      isLoading = true;
      error = null;
      notifyListeners();
      getDetailsMovie(id!);
    }
  }

  clear() {
    id = null;
    error = null;
    openedMovies.clear();
  }
}
