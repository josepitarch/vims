import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/providers/search_movie_provider.dart';
import 'package:scrapper_filmaffinity/widgets/movie_item.dart';

class SearchMovieScreen extends StatelessWidget {
  const SearchMovieScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: _SearchMovieForm(),
      ),
    ));
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
            ? const _Suggestions()
            : const _SearchHistory()
      ],
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchMovieProvider>(builder: (context, provider, _) {
      return Expanded(
        child: ListView.builder(
          itemCount: provider.movies.length,
          itemBuilder: (context, index) => MovieItem(
            movie: provider.movies[index],
            hasAllAttributes: true,
          ),
        ),
      );
    });
  }
}

class _SearchHistory extends StatelessWidget {
  const _SearchHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
