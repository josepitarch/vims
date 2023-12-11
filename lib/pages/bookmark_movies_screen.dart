import 'dart:io' as io show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vims/dialogs/delete_all_bookmarks_dialog.dart';
import 'package:vims/providers/implementation/bookmark_movies_provider.dart';
import 'package:vims/widgets/card_movie.dart';
import 'package:vims/widgets/title_page.dart';

class BookmarkMoviesScreen extends StatelessWidget {
  const BookmarkMoviesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, BookmarkMoviesProvider provider, _) {
      final i18n = AppLocalizations.of(context)!;

      return Scaffold(
        body: SafeArea(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TitlePage(i18n.title_bookmarks_page),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () => _openDialog(context).then((value) {
                      if (value != null && value)
                        provider.deleteAllBookmarkMovies();
                    }),
                icon: const Icon(Icons.delete)),
          ),
          provider.data!.isEmpty
              ? const NoBookmarkMovies()
              : Expanded(
                  child: ListView(
                      children: provider.data!
                          .map(
                            (movie) => CardMovie(
                                id: movie.id,
                                title: movie.title,
                                poster: movie.poster,
                                saveToCache: true),
                          )
                          .toList()))
        ])),
      );
    });
  }

  Future _openDialog(BuildContext context) {
    final bool isAndroid = io.Platform.isAndroid;
    return isAndroid
        ? showDialog(
            context: context,
            builder: (BuildContext context) =>
                DeleteAllBookmarksDialog(isAndroid: isAndroid))
        : showCupertinoDialog(
            context: context,
            builder: (BuildContext context) =>
                DeleteAllBookmarksDialog(isAndroid: isAndroid));
  }
}

class NoBookmarkMovies extends StatelessWidget {
  const NoBookmarkMovies({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;

    return Expanded(
      child: Container(
        transform: Matrix4.translationValues(0, -50, 0),
        child: Column(
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
        ),
      ),
    );
  }
}
