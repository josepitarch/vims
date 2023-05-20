import 'package:vims/models/movie.dart';
import 'package:vims/providers/interface/base_providert.dart';
import 'package:vims/services/movie_service.dart';

class DetailsMovieProvider extends BaseProvider<Map<int, Movie>> {
  late int id;
  DetailsMovieProvider() : super(data: {}, isLoading: true);

  getDetailsMovie(int id) {
    this.id = id;
    DetailsMovieService()
        .getMovie(id)
        .then((movie) {
          data[movie.id] = movie;
          exception = null;
        })
        .catchError((e) => exception = e)
        .whenComplete(() {
          isLoading = false;
          notifyListeners();
        });
  }

  @override
  onRefresh() async {
    isLoading = true;
    exception = null;
    notifyListeners();
    getDetailsMovie(id);
  }

  clear() {
    exception = null;
    data.clear();
  }
}
