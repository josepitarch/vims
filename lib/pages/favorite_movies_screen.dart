import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/models/favorite_movie.dart';
import 'package:scrapper_filmaffinity/providers/favorite_movies_provider.dart';
import 'package:scrapper_filmaffinity/widgets/movie_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavouritesMovies extends StatelessWidget {
  const FavouritesMovies({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    final FavoriteMovieProvider favoriteMovieProvider =
        Provider.of<FavoriteMovieProvider>(context);

    favoriteMovieProvider.getFavoriteMovies();

    final List<FavoriteMovie> favoriteMovies =
        favoriteMovieProvider.favoriteMovies;

    Widget body = favoriteMovies.isNotEmpty
        ? FavoriteMoviesList(favoriteMovies)
        : Center(child: Text(localization!.no_favorites));

    return body;
  }
}

class FavoriteMoviesList extends StatelessWidget {
  final List<FavoriteMovie> favoriteMovies;

  const FavoriteMoviesList(this.favoriteMovies, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: favoriteMovies.length,
            itemBuilder: (_, index) {
              return MovieItem(
                movie: favoriteMovies[index].toMovie(),
                isFavorite: true,
              );
            }));
  }
}
