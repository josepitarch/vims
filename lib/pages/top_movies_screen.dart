import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/dialogs/TopMoviesDialog.dart';
import 'package:scrapper_filmaffinity/providers/top_movies_provider.dart';
import 'package:scrapper_filmaffinity/shimmer/card_movie_shimmer.dart';
import 'package:scrapper_filmaffinity/widgets/card_movie.dart';
import 'package:scrapper_filmaffinity/widgets/timeout_error.dart';
import 'package:scrapper_filmaffinity/widgets/title_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late AppLocalizations i18n;

class TopMoviesScreen extends StatefulWidget {
  const TopMoviesScreen({Key? key}) : super(key: key);

  @override
  State<TopMoviesScreen> createState() => _TopMoviesScreenState();
}

class _TopMoviesScreenState extends State<TopMoviesScreen> {
  late TopMoviesProvider topMoviesProvider;
  final scrollController = ScrollController();
  bool showFloatingActionButton = false;
  late int totalMovies;
  int pagination = 30;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= 200) {
        setState(() {
          showFloatingActionButton = true;
        });
      } else {
        setState(() {
          showFloatingActionButton = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context)!;

    return Consumer<TopMoviesProvider>(builder: (_, provider, __) {
      topMoviesProvider = provider;
      if (provider.existsError) {
        return TimeoutError(onPressed: () => provider.onFresh());
      }

      return Scaffold(
          body: SafeArea(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                TitlePage(i18n.title_top_movies_page),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () {
                        pagination = 30;
                        provider.movies.clear();
                        showDialogFilters(context, provider, scrollController);
                      },
                      icon: const Icon(Icons.filter_list_rounded)),
                ),
                Expanded(
                    child: ListView(
                  controller: scrollController,
                  children: [
                    if (provider.isLoading)
                      ...List.generate(20, (index) => const CardMovieShimmer())
                    else if (provider.movies.isEmpty)
                      const Center(
                          child: Text('No hay películas que mostrar',
                              style: TextStyle(fontSize: 20)))
                    else
                      ...provider.movies.map((movie) => CardMovie(movie: movie))
                  ],
                ))
              ])),
          floatingActionButton: showFloatingActionButton
              ? FloatingActionButton(
                  shape: const CircleBorder(),
                  onPressed: () => scrollController.animateTo(0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut),
                  child: const Icon(Icons.arrow_upward_rounded))
              : null);
    });
  }

  Future<dynamic> showDialogFilters(BuildContext context,
      TopMoviesProvider provider, ScrollController scrollController) {
    return showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: TopMoviesDialog(
                provider: provider, scrollController: scrollController),
          );
        });
  }
}
