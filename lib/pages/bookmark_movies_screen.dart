import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vims/dialogs/delete_bookmark_dialog.dart';
import 'package:vims/providers/implementation/bookmarks_provider.dart';
import 'package:vims/widgets/card_movie.dart';

class BookmarkMoviesScreen extends StatelessWidget {
  const BookmarkMoviesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final BookmarksProvider provider = Provider.of<BookmarksProvider>(context);

    final i18n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.title_bookmarks_page),
      ),
      body: provider.data!.isEmpty
          ? const NoBookmarkMovies()
          : ListView(
              children: provider.data!
                  .map(
                    (movie) => InkWell(
                      onLongPress: () => _openDialog(context).then((value) =>
                          {if (value) provider.removeBookmark(movie.id)}),
                      child: CardMovie(
                          id: movie.id,
                          title: movie.title,
                          poster: movie.poster,
                          saveToCache: true),
                    ),
                  )
                  .toList()),
    );
  }

  Future _openDialog(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser!;
    return Theme.of(context).platform == TargetPlatform.android
        ? showDialog(
            context: context,
            builder: (BuildContext context) =>
                DeleteBookmarkDialog(userId: user.uid, movieId: 1))
        : showCupertinoDialog(
            context: context,
            builder: (BuildContext context) =>
                DeleteBookmarkDialog(userId: user.uid, movieId: 1));
  }
}

class NoBookmarkMovies extends StatelessWidget {
  const NoBookmarkMovies({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/bookmark.png',
          width: 100,
          height: 100,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: Text(i18n.no_bookmarks,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge),
        ),
      ],
    );
  }
}
