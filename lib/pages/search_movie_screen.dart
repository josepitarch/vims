import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/providers/search_movie_provider.dart';
import 'package:scrapper_filmaffinity/shimmer/card_movie_shimmer.dart';
import 'package:scrapper_filmaffinity/ui/input_decoration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scrapper_filmaffinity/widgets/card_movie.dart';
import 'package:scrapper_filmaffinity/widgets/no_results.dart';
import 'package:scrapper_filmaffinity/widgets/timeout_error.dart';
import 'dart:io' as io show Platform;

late AppLocalizations i18n;

class SearchMovieScreen extends StatelessWidget {
  const SearchMovieScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context)!;

    return Consumer<SearchMovieProvider>(builder: (_, provider, __) {
      if (provider.error != null)
        return TimeoutError(provider.error!, provider);
      if (provider.isLoading) {
        return SafeArea(
          child: Column(children: [
            const _SearchMovieForm(),
            Expanded(
                child: ListView(
                    children:
                        List.generate(20, (index) => const CardMovieShimmer())))
          ]),
        );
      }
      return SafeArea(
        child: Column(children: [
          const _SearchMovieForm(),
          provider.search.isNotEmpty
              ? _Suggestions(
                  movies: provider.movies,
                  numberFetchMovies: provider.numberFetchMovies)
              : _HistorySearch(
                  historySearch: provider.searchs, provider: provider)
        ]),
      );
    });
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
    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();

    FocusScope.of(context).requestFocus(FocusNode());

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: myFormKey,
        child: TextFormField(
          controller: controller..text = provider.search,
          keyboardType: TextInputType.text,
          enableSuggestions: false,
          keyboardAppearance: Brightness.dark,
          decoration: InputDecorations.searchMovieDecoration(
              i18n, controller, provider),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value!.isEmpty) return i18n.no_empty_search;

            return null;
          },
          onFieldSubmitted: (String value) {
            if (myFormKey.currentState!.validate()) {
              provider.searchMovie(value);
              provider.insertHistorySearch(value);
            } else {
              return;
            }
          },
        ),
      ),
    );
  }
}

class _Suggestions extends StatelessWidget {
  final List movies;
  final int numberFetchMovies;
  const _Suggestions(
      {Key? key, required this.movies, required this.numberFetchMovies})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return movies.isNotEmpty
        ? Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                bool hasAllAttributes = index < numberFetchMovies;
                Movie movie = index < numberFetchMovies
                    ? Movie.fromMap(movies[index])
                    : Movie.fromIncompleteMovie(movies[index]);
                return CardMovie(
                  movie: movie,
                  hasAllAttributes: hasAllAttributes,
                  saveToCache: false,
                );
              },
            ),
          )
        : const NoResults();
  }
}

class _HistorySearch extends StatelessWidget {
  final List<String> historySearch;
  final SearchMovieProvider provider;
  const _HistorySearch(
      {Key? key, required this.historySearch, required this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (historySearch.isEmpty) return const SizedBox();
    return Expanded(
      child: SingleChildScrollView(
        child: Column(children: [
          ...historySearch.map((e) {
            return ListTile(
              leading: const Icon(Icons.history),
              trailing: const Icon(Icons.arrow_forward_ios),
              title: Text(e, style: Theme.of(context).textTheme.bodyText1),
              onTap: () => provider.onTapHistorySearch(e),
            );
          }).toList(),
          DeleteSearchersButton(provider: provider),
        ]),
      ),
    );
  }
}

class DeleteSearchersButton extends StatelessWidget {
  const DeleteSearchersButton({
    Key? key,
    required this.provider,
  }) : super(key: key);

  final SearchMovieProvider provider;

  @override
  Widget build(BuildContext context) {
    return io.Platform.isAndroid
        ? MaterialButton(
            onPressed: () => provider.deleteAllSearchs(),
            child: Text(i18n.delete_all_searchers, style: _textStyle(context)))
        : CupertinoButton(
            child: Text(i18n.delete_all_searchers, style: _textStyle(context)),
            onPressed: () => provider.deleteAllSearchs());
  }

  _textStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.red);
  }
}
