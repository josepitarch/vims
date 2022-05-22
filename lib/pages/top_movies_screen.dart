import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/providers/topMoviesProvider.dart';
import 'package:scrapper_filmaffinity/widgets/loading.dart';

import '../widgets/movie_item.dart';

class TopMoviesScreen extends StatelessWidget {
  const TopMoviesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topMoviesProvider = Provider.of<TopMoviesProvider>(context);

    Widget body = topMoviesProvider.movies.isNotEmpty
        ? _Body(movies: topMoviesProvider.movies)
        : const Loading();

    if (topMoviesProvider.existsError) {
      body = const Center(child: Text('Error'));
    }

    return body;
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key, required this.movies}) : super(key: key);

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {
                    //topMoviesProvider.selectedMovie = movies[index];
                    Navigator.pushNamed(context, 'details',
                        arguments: movies[index]);
                  },
                  child: MovieItem(
                    title: movies[index].title,
                    imageUrl: movies[index].poster,
                    director: movies[index].director,
                  ),
                );
              })),
    );
  }
}
