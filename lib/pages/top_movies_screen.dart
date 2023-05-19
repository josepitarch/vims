import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vims/dialogs/top_filters_dialog.dart';
import 'package:vims/enums/mode_views.dart';
import 'package:vims/models/topMovie.dart';
import 'package:vims/providers/top_movies_provider.dart';
import 'package:vims/shimmer/card_movie_shimmer.dart';
import 'package:vims/widgets/card_movie.dart';
import 'package:vims/widgets/handle_error.dart';
import 'package:vims/widgets/loading.dart';
import 'package:vims/widgets/no_results.dart';
import 'package:vims/widgets/title_page.dart';

late AppLocalizations i18n;
late ScrollController scrollController;
const double limitShowFab = 300;

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
    final TopMoviesProvider provider =
        Provider.of<TopMoviesProvider>(context, listen: false);
    scrollController =
        ScrollController(initialScrollOffset: provider.scrollPosition);

    setState(() {
      showFloatingActionButton = provider.scrollPosition >= limitShowFab;
    });
    scrollController.addListener(() {
      provider.scrollPosition = scrollController.position.pixels;
      if (provider.scrollPosition >= limitShowFab &&
          !showFloatingActionButton) {
        setState(() {
          showFloatingActionButton = true;
        });
      } else if (provider.scrollPosition < limitShowFab &&
          showFloatingActionButton) {
        setState(() {
          showFloatingActionButton = false;
        });
      }
      if (scrollController.position.pixels + 300 >=
          scrollController.position.maxScrollExtent) {
        if (!provider.isLoading) provider.getTopMovies();
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
        return HandleError(provider.error!, provider.onRefresh);
      }

      return Scaffold(
          body: SafeArea(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                TitlePage(i18n.title_top_movies_page),
                _Options(provider: provider),
                (!provider.isLoading && provider.topMovies.results.isEmpty)
                    ? const NoResults()
                    : Expanded(
                        child: _Body(
                            movies: provider.topMovies.results,
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
    final ModeView modeView = provider.modeView;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // IconButton(
        //     icon: Icon(
        //         modeView == ModeView.list ? Icons.list : Icons.apps_rounded),
        //     onPressed: () => provider.setModeView()),
        IconButton(
            onPressed: () {
              showDialogFilters(context, provider);
            },
            icon: const Icon(Icons.filter_list_rounded)),
      ],
    );
  }

  showDialogFilters(BuildContext context, TopMoviesProvider provider) {
    return showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => TopMoviesDialog(
            topMoviesProvider: provider, controller: scrollController));
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
  final List<TopMovie> movies;
  final bool isLoading;
  const _Body({Key? key, required this.movies, required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TopMoviesProvider provider = Provider.of<TopMoviesProvider>(context);
    if (isLoading && movies.isEmpty) return const CardMovieShimmer();
    final double left = MediaQuery.of(context).size.width * 0.5 - 30;
    return Stack(children: [
      ListView(
          controller: scrollController,
          children: movies
              .map((movie) => CardMovie(movie: movie, saveToCache: false))
              .toList()),
      Positioned(
          bottom: 10,
          left: left,
          child: provider.isLoading ? const Loading() : const SizedBox())
    ]);
  }
}
