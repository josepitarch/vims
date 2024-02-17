import 'package:firebase_auth/firebase_auth.dart';
import 'package:vims/models/review.dart';
import 'package:vims/providers/interface/infinite_scroll_provider.dart';
import 'package:vims/services/api/user_service.dart';

final class UserReviewsProvider extends InfiniteScrollProvider<UserReview> {
  UserReviewsProvider() : super(page: 1, limit: 20) {
    fetchData();
  }
  @override
  fetchData() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        data = null;
        total = null;
        hasNextPage = false;
        notifyListeners();
      } else {
        getUserReviews(user.uid, page, limit)
            .then((value) => {
                  data == null
                      ? data = List.of(value.results)
                      : data!.addAll(value.results),
                  total = value.total,
                  hasNextPage = value.results.length == limit,
                  exception = null,
                })
            .catchError((e) {
          exception = e;
        }).whenComplete(() {
          isLoading = false;
          notifyListeners();
        });
      }
    });
  }
}
