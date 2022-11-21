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

      return Scaffold(
        body: SafeArea(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TitlePage(i18n.title_bookmarks_page),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Basic dialog title'),
                        content: const Text(
                            'A dialog is a type of modal window that\n'
                            'appears in front of app content to\n'
                            'provide critical information, or prompt\n'
                            'for a decision to be made.'),
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('Disable'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('Enable'),
                            onPressed: () {
                              provider.deleteAllBookmarkMovies();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }),
                icon: const Icon(Icons.delete)),
          ),
          provider.bookmarkMovies.isEmpty
              ? const NoBookmarkMovies()
              : Expanded(
                  child: ListView(
                      children: provider.bookmarkMovies
                          .map(
                            (movie) => CardMovie(
                                movie: movie.toMovie(), saveToCache: true),
                          )
                          .toList()))
        ])),
      );
    });
  }
}

class NoBookmarkMovies extends StatelessWidget {
  const NoBookmarkMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;

    return Expanded(
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
                style: Theme.of(context).textTheme.headline6),
          ),
        ],
      ),
    );
  }
}
