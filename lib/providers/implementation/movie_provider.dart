import 'package:vims/models/movie.dart';
import 'package:vims/providers/interface/base_providert.dart';
import 'package:vims/services/api/movie_service.dart';

class DetailsMovieProvider extends BaseProvider<Map<int, Movie>> {
  late int id;
  DetailsMovieProvider() : super(data: {}, isLoading: true);

  @override
  fetchData() {
    getMovie(id).then((movie) {
      data[movie.id] = movie;
      exception = null;
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  @override
  onRefresh() async {
    isLoading = true;
    exception = null;
    notifyListeners();
    fetchData();
  }

  fetchMovie(int id) {
    this.id = id;
    fetchData();
  }

  clear() {
    exception = null;
    data.clear();
  }
}
