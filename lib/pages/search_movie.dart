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
                controller.clear;
                provider.setSearch('');
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
          itemBuilder: (context, index) {
            bool hasAllAttributes = index <= 2;
            Movie movie = index <= 2
                ? Movie.fromMap(provider.movies[index])
                : Movie.toMovie(provider.movies[index]);
            return MovieItem(
              movie: movie,
              hasAllAttributes: hasAllAttributes,
            );
          },
        ),
      );
    });
  }
}

class _SearchHistory extends StatelessWidget {
  const _SearchHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: HistorySearchDatabase.retrieveSearchs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => ListTile(
                    title: GestureDetector(
                        onTap: () {
                          final searchMovieProvider =
                              Provider.of<SearchMovieProvider>(context,
                                  listen: false);
                          searchMovieProvider
                              .getSearchMovie(snapshot.data![index]);
                        },
                        child: Text(snapshot.data![index])),
                  ),
                ),
                MaterialButton(
                    onPressed: () => HistorySearchDatabase.deleteAllSearchs(),
                    child: const Text('Delete last searchers')),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
