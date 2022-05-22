import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/services/searchMovieService.dart';
import 'package:scrapper_filmaffinity/widgets/movie_item.dart';

class MovieSearchDelegate extends SearchDelegate {
  MovieSearchDelegate({required this.context});

  BuildContext context;
  final SearchMovieService searchMovieService = SearchMovieService();
  @override
  String? get searchFieldLabel => AppLocalizations.of(context)!.search_film;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: searchMovieService.getSuggestions(query),
        builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Movie> movies = snapshot.data!;

          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'details',
                        arguments: movies[index]);
                  },
                  child: MovieItem(
                    imageUrl: movies[index].poster,
                    title: movies[index].title,
                    director: movies[index].director,
                  ),
                );
              });
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
        child: Icon(Icons.movie_creation_outlined,
            color: Colors.white24, size: 100));
  }
}
