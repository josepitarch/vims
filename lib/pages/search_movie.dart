import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/providers/search_movie_provider.dart';
import 'package:scrapper_filmaffinity/widgets/movie_item.dart';

class SearchMovieScreen extends StatelessWidget {
  const SearchMovieScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchMovieProvider = Provider.of<SearchMovieProvider>(context);
    String search = searchMovieProvider.search;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Flex(
              direction: Axis.vertical, children: const [_SearchMovieForm()]),
        ),
      ),
    );
  }
}

class _SearchMovieForm extends StatelessWidget {
  const _SearchMovieForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchMovieProvider = Provider.of<SearchMovieProvider>(context);

    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Search movie',
          ),
          controller: TextEditingController()
            ..text = searchMovieProvider.search,
          onFieldSubmitted: (String value) {
            searchMovieProvider.getSearchMovie(value);
            print(value);
          },
        ),
        searchMovieProvider.search.isNotEmpty
            ? _Suggestions(searchMovieProvider.search)
            : const _SearchHistory()
      ],
    );
  }
}

class _Suggestions extends StatelessWidget {
  String search;
  _Suggestions(this.search, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchMovieProvider = Provider.of<SearchMovieProvider>(context);
    final List<Movie> movies = searchMovieProvider.movies;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: movies.length,
        itemBuilder: (_, index) {
          return MovieItem(
            movie: movies[index],
            hasAllAttributes: true,
          );
        });
  }
}

class _SearchHistory extends StatelessWidget {
  const _SearchHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (_, __) {
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, __) {
            return const Text('No search history');
          });
    });
  }
}
