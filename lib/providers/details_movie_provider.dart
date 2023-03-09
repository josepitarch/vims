import 'package:flutter/cupertino.dart';

import 'package:vims/models/movie.dart';
import 'package:vims/services/details_movie_service.dart';
import 'package:logger/logger.dart';

class DetailsMovieProvider extends ChangeNotifier {
  int? id;
  bool isLoading = true;
  Exception? error;
  final Map<int, Movie> openedMovies = {};
  final logger = Logger();

  DetailsMovieProvider();

  getDetailsMovie(int id) async {
    try {
      Movie? movie = await DetailsMovieService().getDetailsMovie(id);
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
