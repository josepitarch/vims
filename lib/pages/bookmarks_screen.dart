import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vims/dialogs/delete_bookmark_dialog.dart';
import 'package:vims/pages/error/error_screen.dart';
import 'package:vims/providers/implementation/bookmarks_provider.dart';
import 'package:vims/widgets/card_movie.dart';
import 'package:vims/widgets/shimmer/card_movie_shimmer.dart';

class BookmarkMoviesScreen extends StatelessWidget {
  const BookmarkMoviesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final BookmarksProvider provider = Provider.of<BookmarksProvider>(context);

    final i18n = AppLocalizations.of(context)!;

    if (provider.exception != null) {
      return ErrorScreen(provider.exception!, provider.onRefresh);
    }

    Widget body;

    if (provider.isLoading && provider.data == null) {
      body = const CardMovieShimmer();
    } else if (!provider.isLoading && provider.data!.isEmpty) {
      body = const NoBookmarkMovies();
    } else {
      final bookmarks = provider.data!
          .map((bookmark) => InkWell(
                onLongPress: () => _openDialog(context).then((value) =>
                    {if (value) provider.removeBookmark(bookmark.id)}),
                child: CardMovie(
                  id: bookmark.id,
                  title: bookmark.title,
                  poster: bookmark.poster,
                  saveToCache: true,
                ),
              ))
          .toList();

      body = ListView(
        children: [
          ...bookmarks,
          const SizedBox(height: 30),
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(i18n.title_bookmarks_page),
        ),
        body: RefreshIndicator.adaptive(
            child: body,
            onRefresh: () {
              return provider.onRefresh();
            }));
  }

  Future _openDialog(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.android
        ? showDialog(
            context: context,
            builder: (BuildContext context) => const DeleteBookmarkDialog())
        : showCupertinoDialog(
            context: context,
            builder: (BuildContext context) => const DeleteBookmarkDialog());
  }
}

class NoBookmarkMovies extends StatelessWidget {
  const NoBookmarkMovies({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;

    return Center(
      child: Text(i18n.no_bookmarks,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
