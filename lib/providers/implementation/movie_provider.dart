import 'package:vims/models/movie.dart';
import 'package:vims/models/movie_friend.dart';
import 'package:vims/models/review.dart';
import 'package:vims/providers/interface/base_providert.dart';
import 'package:vims/services/api/movie_service.dart';

final class MovieProvider extends BaseProvider<Map<int, Movie>> {
  late int id;
  Map<int, List<MovieFriend>> friends = {};
  bool isFriendsLoading = false;

  MovieProvider() : super(data: {}, isLoading: false);

  @override
  fetchData() {
    if (data!.containsKey(id) || isLoading) return;

    isLoading = true;

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

  fetchMovieFriends(int id) async {
    if (friends.containsKey(id) || isFriendsLoading) return;

    isFriendsLoading = true;

    getMovieFriends(id)
        .then((movies) {
          friends.putIfAbsent(id, () => movies);
        })
        .catchError((e) {})
        .whenComplete(() {
          isFriendsLoading = false;
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
    fetchMovieFriends(id);
  }

  clear() {
    exception = null;
    data!.clear();
    friends.clear();
  }

  Future<UserReview> createReview(
      String userId, int movieId, UserReview review) {
    return createUserReview(userId, movieId, review).then((userReview) {
      data![movieId]!.reviews.users.add(userReview);
      exception = null;
      return userReview;
    }).catchError((e) {
      // TODO: show error message
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
