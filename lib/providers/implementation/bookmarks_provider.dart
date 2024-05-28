import 'package:firebase_auth/firebase_auth.dart';
import 'package:vims/models/bookmark_movie.dart';
import 'package:vims/models/movie.dart';
import 'package:vims/providers/interface/infinite_scroll_provider.dart';
import 'package:vims/services/api/user_service.dart';

final class BookmarksProvider extends InfiniteScrollProvider<BookmarkMovie> {
  BookmarksProvider() : super(page: 1, limit: 20) {
    fetchData();
  }

  @override
  fetchData() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        data = null;
        total = null;
        hasNextPage = false;
        notifyListeners();
      } else {
        isLoading = true;
        notifyListeners();
        getBookmarks(user.uid, page, limit)
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

  Future<bool> insertBookmarkMovie(Movie movie) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final bookmarkMovie = BookmarkMovie(
      id: movie.id,
      poster: movie.poster.large,
      title: movie.title,
      director: movie.director ?? '',
    );

    await createBookmark(user.uid, bookmarkMovie);
    data!.add(bookmarkMovie);
    notifyListeners();

    return true;
  }

  removeBookmark(int bookmarkId) {
    final User user = FirebaseAuth.instance.currentUser!;
    deleteBookmark(user.uid, bookmarkId)
        .then((value) => {
              data!.removeWhere((element) => element.id == bookmarkId),
              total = data!.length,
              notifyListeners(),
            })
        .catchError((e) {
      exception = e;
      notifyListeners();
    });
  }
}
