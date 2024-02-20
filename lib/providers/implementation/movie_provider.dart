import 'package:vims/models/movie.dart';
import 'package:vims/models/review.dart';
import 'package:vims/providers/interface/base_providert.dart';
import 'package:vims/services/api/movie_service.dart';

final class MovieProvider extends BaseProvider<Map<int, Movie>> {
  late int id;
  MovieProvider() : super(data: {}, isLoading: true);

  @override
  fetchData() {
    getMovie(id).then((movie) {
      data![movie.id] = movie;
      exception = null;
    }).catchError((e) {
      exception = e;
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
    data!.clear();
  }

  createReview(String userId, int movieId, UserReview review) {
    createUserReview(userId, movieId, review).then((userReview) {
      data![movieId]!.reviews.users.add(userReview);
      exception = null;
    }).catchError((e) {
      // TODO: show error message
      print(e);
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  removeReview(int movieId, int reviewId) {
    data![movieId]!
        .reviews
        .users
        .removeWhere((element) => element.id == reviewId);
    notifyListeners();
  }
}
