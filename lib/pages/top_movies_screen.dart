import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/dialogs/order_by_dialog.dart';
import 'package:scrapper_filmaffinity/dialogs/top_filters_dialog.dart';
import 'package:scrapper_filmaffinity/enums/mode_views.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/providers/top_movies_provider.dart';
import 'package:scrapper_filmaffinity/shimmer/card_movie_shimmer.dart';
import 'package:scrapper_filmaffinity/widgets/card_movie.dart';
import 'package:scrapper_filmaffinity/widgets/no_results.dart';
import 'package:scrapper_filmaffinity/widgets/timeout_error.dart';
import 'package:scrapper_filmaffinity/widgets/title_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late AppLocalizations i18n;
late ScrollController scrollController;

class TopMoviesScreen extends StatefulWidget {
  const TopMoviesScreen({Key? key}) : super(key: key);

  @override
  State<TopMoviesScreen> createState() => _TopMoviesScreenState();
}

class _TopMoviesScreenState extends State<TopMoviesScreen> {
  bool showFloatingActionButton = false;
  late int totalMovies;
  int pagination = 30;

  @override
  void initState() {
    scrollController = ScrollController();
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
      if (provider.error != null) {
        return TimeoutError(provider.error!, provider);
      }

      return Scaffold(
          body: SafeArea(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                TitlePage(i18n.title_top_movies_page),
                _Options(provider: provider),
                (!provider.isLoading && provider.movies.isEmpty)
                    ? const NoResults()
                    : Expanded(
                        child: _Body(
                            movies: provider.movies,
                            isLoading: provider.isLoading)),
              ])),
          floatingActionButton:
              showFloatingActionButton ? const _FloatingActionButton() : null);
    });
  }
}

class _Options extends StatelessWidget {
  final TopMoviesProvider provider;
  const _Options({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ModeViews modeView = provider.modeView;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CupertinoButton(
            child: const Text('Ordernar por'),
            onPressed: () => showDialogOrderBy(context)),
        IconButton(
            onPressed: () {
              showDialogFilters(context, provider);
            },
            icon: const Icon(Icons.filter_list_rounded)),
        // IconButton(
        //     icon: Icon(
        //         modeView == ModeViews.list ? Icons.apps_rounded : Icons.list),
        //     onPressed: () => setModeView(context, modeView)),
      ],
    );
  }

  Future<dynamic> showDialogFilters(
      BuildContext context, TopMoviesProvider provider) {
    return showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => TopMoviesDialog(
            provider: provider, scrollController: scrollController));
  }

  Future<dynamic> showDialogOrderBy(BuildContext context) {
    return showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => const OrderByDialog());
  }

  setModeView(BuildContext context, ModeViews modeView) {
    ModeViews newModeView =
        modeView == ModeViews.list ? ModeViews.grid : ModeViews.list;

    context.read<TopMoviesProvider>().setModeView(newModeView);
  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => scrollController.animateTo(0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut),
        child: const Icon(Icons.arrow_upward_rounded));
  }
}

class _Body extends StatelessWidget {
  final List<Movie> movies;
  final bool isLoading;
  const _Body({Key? key, required this.movies, required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? ListView.builder(
            itemCount: 20, itemBuilder: (_, __) => const CardMovieShimmer())
        : ListView(
            controller: scrollController,
            children: movies
                .map((movie) => CardMovie(movie: movie, saveToCache: false))
                .toList());
  }
}

class CardMoviesLoading extends StatelessWidget {
  const CardMoviesLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 20, itemBuilder: (_, __) => const CardMovieShimmer());
  }
}

class CardMovies extends StatelessWidget {
  final List<Movie> movies;
  const CardMovies({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView(
        controller: scrollController,
        children: movies
            .map((movie) => CardMovie(movie: movie, saveToCache: false))
            .toList());
  }
}
