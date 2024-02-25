import 'package:vims/models/bookmark_movie.dart';
import 'package:vims/models/enums/http_method.dart';
import 'package:vims/models/paged_response.dart';
import 'package:vims/models/review.dart';
import 'package:vims/utils/api.dart';

Future<PagedResponse<UserReview>> getUserReviews(
    String userId, int page, int size) async {
  final Map<String, dynamic> response = await api('users/$userId/reviews', 1);

  final List<UserReview> results = response['results']
      .map<UserReview>((topMovie) => UserReview.fromMap(topMovie))
      .toList();

  return PagedResponse<UserReview>(
      page: response['page'], limit: response['limit'], results: results);
}

Future<void> deleteUserReview(int movieId, int reviewId) async {
  return await api('movie/$movieId/reviews/$reviewId', 1,
      method: HttpMethod.DELETE);
}

Future<PagedResponse<BookmarkMovie>> getBookmarks(
    String userId, int page, int size) async {
  final Map<String, dynamic> response = await api('users/$userId/bookmarks', 1);

  final List<BookmarkMovie> results = response['results']
      .map<BookmarkMovie>(
          (bookmarkMovie) => BookmarkMovie.fromMap(bookmarkMovie))
      .toList();

  return PagedResponse<BookmarkMovie>(
      page: response['page'], limit: response['limit'], results: results);
}

Future<void> createBookmark(String userId, BookmarkMovie bookmarkMovie) async {
  return await api('users/$userId/bookmarks', 1,
      method: HttpMethod.POST, body: {'bookmark': bookmarkMovie.toMap()});
}

Future<void> deleteBookmark(String userId, int movieId) async {
  return await api('users/$userId/bookmarks/$movieId', 1,
      method: HttpMethod.DELETE);
}

Future<void> deleteAccount(String userId) async {
  return await api('users/$userId', 1, method: HttpMethod.DELETE);
}
