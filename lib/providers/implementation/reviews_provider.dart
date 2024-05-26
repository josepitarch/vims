import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:vims/models/review.dart';
import 'package:vims/providers/interface/infinite_scroll_provider.dart';
import 'package:vims/services/api/user_service.dart';

final class UserReviewsProvider extends InfiniteScrollProvider<UserReview> {
  UserReviewsProvider() : super(page: 1, limit: 20) {
    fetchData();
  }

  @override
  fetchData() {
    isLoading = true;
    notifyListeners();
    final User user = FirebaseAuth.instance.currentUser!;
    getUserReviews(user.uid, page, limit).then((value) {
      data == null
          ? data = List.of(value.results)
          : data!.addAll(value.results);
      total = value.total;
      hasNextPage = value.results.length == limit;
      exception = null;
    }).catchError((e) {
      exception = e;
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  deleteReview(UserReview review) {
    deleteUserReview(review.movieId, review.id).then((value) {
      data!.removeWhere((element) => element.id == review.id);
      total = data!.length;
    }).catchError((e) {
      exception = e;
    }).whenComplete(() => notifyListeners());
  }
}
