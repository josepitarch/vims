import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/providers/bookmark_movies_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scrapper_filmaffinity/widgets/card_movie.dart';
import 'package:scrapper_filmaffinity/widgets/title_page.dart';

class BookmarkMoviesScreen extends StatelessWidget {
  const BookmarkMoviesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, BookmarkMoviesProvider provider, _) {
      final i18n = AppLocalizations.of(context)!;
      provider.getBookmarkMovies();
      if (provider.bookmarkMovies.isEmpty) {
        return Center(
            child: Text(i18n.no_bookmarks,
                style: Theme.of(context).textTheme.headline6));
      }

      return Scaffold(
        body: SafeArea(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TitlePage(i18n.title_bookmarks_page),
          Expanded(
              child: ListView(
                  children: provider.bookmarkMovies
                      .map(
                        (movie) => CardMovie(movie: movie.toMovie()),
                      )
                      .toList()))
        ])),
      );
    });
  }
}
