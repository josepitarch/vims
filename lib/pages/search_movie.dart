import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/database/history_search_database.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';
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
    final provider = Provider.of<SearchMovieProvider>(context);
    final TextEditingController controller = TextEditingController();

    return Column(
      children: [
        TextFormField(
          controller: controller..text = provider.search,
          decoration: InputDecoration(
            labelText: 'Search movie',
            suffixIcon: IconButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  controller.clear;
                  provider.setSearch('');
                }
              },
              icon: const Icon(Icons.clear),
            ),
          ),
          onChanged: (value) {
            value.isEmpty ? provider.setSearch('') : null;
          },
          onFieldSubmitted: (String value) {
            provider.getSearchMovie(value);
            HistorySearchDatabase.insertSearch(value);
          },
        ),
        provider.search.isNotEmpty
            ? _Suggestions(movies: provider.movies)
            : _SearchHistory(
                historySearchers: provider.historySearchers,
                provider: provider),
      ],
    );
  }
}

class _Suggestions extends StatelessWidget {
  final List<dynamic> movies;
  const _Suggestions({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          bool hasAllAttributes = index <= 2;
          Movie movie = index <= 2
              ? Movie.fromMap(movies[index])
              : Movie.toMovie(movies[index]);
          return MovieItem(
            movie: movie,
            hasAllAttributes: hasAllAttributes,
          );
        },
      ),
    );
  }
}

class _SearchHistory extends StatelessWidget {
  final List<String> historySearchers;
  final SearchMovieProvider provider;
  const _SearchHistory(
      {Key? key, required this.historySearchers, required this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: historySearchers.length,
            itemBuilder: (context, index) => ListTile(
              title: GestureDetector(
                  onTap: () {
                    provider.getSearchMovie(provider.historySearchers[index]);
                  },
                  child: Text(historySearchers[index])),
            ),
          ),
          if (historySearchers.isNotEmpty)
            MaterialButton(
                onPressed: () => provider.deleteAllSearchers(),
                child: const Text('Delete last searchers',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ))),
        ],
      ),
    );
  }
}
