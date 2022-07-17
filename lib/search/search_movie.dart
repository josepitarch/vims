import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/services/search_movie_service.dart';
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
        builder: (_, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<dynamic> suggestions = snapshot.data!;

          return ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (_, index) {
                bool hasAllAttributes = index <= 2;
                return MovieItem(
                  movie: Movie.fromMap(suggestions[index]),
                  hasAllAttributes: hasAllAttributes,
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
