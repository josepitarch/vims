import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/providers/search_movie_provider.dart';
import 'package:scrapper_filmaffinity/ui/input_decoration.dart';
import 'package:scrapper_filmaffinity/widgets/movie_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchMovieScreen extends StatelessWidget {
  const SearchMovieScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
      child: _SearchMovieForm(),
    ));
  }
}

class _SearchMovieForm extends StatelessWidget {
  const _SearchMovieForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('build _SearchMovieForm');
    final provider = Provider.of<SearchMovieProvider>(context);
    final TextEditingController controller = TextEditingController();
    final FocusNode focusNode = FocusNode();
    final localization = AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextFormField(
            focusNode: focusNode,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: controller..text = provider.search,
            keyboardType: TextInputType.text,
            enableSuggestions: false,
            decoration: InputDecorations.searchMovieDecoration(
                localization, controller, provider),
            onChanged: (value) {
              value.isEmpty ? provider.setSearch('') : null;
            },
            onFieldSubmitted: (String value) {
              provider.searchAndInsertMovie(value);
            },
          ),
        ),
        provider.search.isNotEmpty
            ? _Suggestions(movies: provider.movies)
            : _SearchHistory(
                historySearchers: provider.searchs, provider: provider),
      ],
    );
  }
}

class _Suggestions extends StatelessWidget {
  final List<dynamic> movies;
  const _Suggestions({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('build _Suggestions');
    final localization = AppLocalizations.of(context)!;
    return movies.isNotEmpty
        ? Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                bool hasAllAttributes = index <= 2;
                Movie movie = index <= 2
                    ? Movie.fromMap(movies[index])
                    : Movie.fromIncompleteMovie(movies[index]);
                return MovieItem(
                  movie: movie,
                  hasAllAttributes: hasAllAttributes,
                );
              },
            ),
          )
        : Expanded(
            child: Center(
              child: Text(
                localization.no_results,
                style: const TextStyle(fontSize: 20),
              ),
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
    final localization = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: historySearchers.length,
            itemBuilder: (context, index) => ListTile(
              leading: const Icon(Icons.history),
              trailing: const Icon(Icons.arrow_forward_ios),
              title: Text(historySearchers[index]),
              onTap: () => provider.onTap(historySearchers[index]),
            ),
          ),
          if (historySearchers.isNotEmpty)
            MaterialButton(
                onPressed: () => provider.deleteAllSearchers(),
                child: Text(localization.delete_all_searchers,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ))),
        ],
      ),
    );
  }
}
