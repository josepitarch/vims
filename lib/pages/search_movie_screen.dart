import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/providers/search_movie_provider.dart';
import 'package:scrapper_filmaffinity/shimmer/card_movie_shimmer.dart';
import 'package:scrapper_filmaffinity/ui/input_decoration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scrapper_filmaffinity/widgets/card_movie.dart';
import 'package:scrapper_filmaffinity/widgets/no_results.dart';

late AppLocalizations i18n;

class SearchMovieScreen extends StatelessWidget {
  const SearchMovieScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context)!;
    return Consumer<SearchMovieProvider>(builder: (context, provider, child) {
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
              : _SearchHistory(
                  historySearchers: provider.searchs, provider: provider)
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
          onChanged: (value) {
            value.isEmpty ? provider.setSearch('') : null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value!.isEmpty) {
              return 'El campo no puede estar vacío';
            }
            return null;
          },
          onFieldSubmitted: (String value) {
            if (!myFormKey.currentState!.validate())
              return;
            else
              provider.insertAndSearchMovie(value);
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
                  saveToCache: true,
                );
              },
            ),
          )
        : const NoResults();
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
    if (historySearchers.isEmpty) return const SizedBox();
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: historySearchers.length,
            itemBuilder: (context, index) => ListTile(
              leading: const Icon(Icons.history),
              trailing: const Icon(Icons.arrow_forward_ios),
              title: Text(historySearchers[index],
                  style: Theme.of(context).textTheme.bodyText1),
              onTap: () => provider.onTap(historySearchers[index]),
            ),
          ),
          DeleteSearchersButton(provider: provider),
        ],
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
    return MaterialButton(
        onPressed: () => provider.deleteAllSearchers(),
        child: Text(i18n.delete_all_searchers,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.red)));
  }
}
