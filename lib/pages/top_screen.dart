import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vims/dialogs/top_filters_dialog.dart';
import 'package:vims/pages/error/error_screen.dart';
import 'package:vims/providers/implementation/top_provider.dart';
import 'package:vims/widgets/card_movie.dart';
import 'package:vims/widgets/infinite_scroll.dart';
import 'package:vims/widgets/no_results.dart';
import 'package:vims/widgets/shimmer/card_movie_shimmer.dart';

late AppLocalizations i18n;

class TopMoviesScreen extends StatefulWidget {
  const TopMoviesScreen({super.key});

  @override
  State<TopMoviesScreen> createState() => _TopMoviesScreenState();
}

class _TopMoviesScreenState extends State<TopMoviesScreen> {
  late ScrollController scrollController;
  bool showFloatingActionButton = false;

  @override
  void initState() {
    const double limitShowFab = 300;
    final TopMoviesProvider provider = context.read<TopMoviesProvider>();
    scrollController =
        ScrollController(initialScrollOffset: provider.scrollPosition);

    setState(() =>
        showFloatingActionButton = provider.scrollPosition >= limitShowFab);

    scrollController.addListener(() {
      final double currentScrollPosition = scrollController.position.pixels;
      provider.scrollPosition = currentScrollPosition;
      if (currentScrollPosition >= limitShowFab && !showFloatingActionButton) {
        setState(() => showFloatingActionButton = true);
      } else if (currentScrollPosition < limitShowFab &&
          showFloatingActionButton) {
        setState(() => showFloatingActionButton = false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context)!;
    final TopMoviesProvider provider = Provider.of(context, listen: true);

    if (provider.exception != null) {
      return ErrorScreen(provider.exception!, provider.onRefresh);
    }

    Widget body;

    if (provider.isLoading && provider.data == null) {
      body = const CardMovieShimmer();
    } else if (!provider.isLoading && provider.data!.isEmpty) {
      if (provider.currentFilters.genres.length >= 3) {
        body = Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const NoResults(),
          const SizedBox(height: 20),
          // TODO: use i18n
          Text(
            'Recuerda que las películas deben contener todos los géneros seleccionados. Prueba a seleccionar menos.',
            softWrap: true,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ]);
      } else {
        body = const Center(child: NoResults());
      }
    } else {
      body = _TopMovies(scrollController: scrollController);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(i18n.title_top_movies_page),
          actions: [
            IconButton(
                onPressed: () {
                  showCupertinoDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) =>
                          const TopMoviesDialog()).then((value) {
                    if (value) {
                      scrollController.jumpTo(0);
                      provider.scrollPosition = 0;
                    }
                  });
                },
                icon: const Icon(Icons.filter_list_rounded)),
            // IconButton(
            //     icon: Icon(provider.modeView == ModeView.list
            //         ? Icons.list
            //         : Icons.apps_rounded),
            //     onPressed: () => provider.setModeView())
          ],
        ),
        body: body,
        floatingActionButton: showFloatingActionButton
            ? _FloatingActionButton(scrollController: scrollController)
            : null);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

class _FloatingActionButton extends StatelessWidget {
  final ScrollController scrollController;
  const _FloatingActionButton({required this.scrollController});

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

class _TopMovies extends StatelessWidget {
  final ScrollController scrollController;
  const _TopMovies({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final TopMoviesProvider provider = Provider.of(context, listen: false);

    final Widget data = ListView(
        controller: scrollController,
        children: provider.data!
            .map((movie) => CardMovie(
                id: movie.id,
                poster: movie.poster.mmed,
                title: movie.title,
                director: movie.director,
                rating: movie.rating,
                platforms: movie.platforms,
                saveToCache: false))
            .toList());

    return InfiniteScroll(
      provider: provider,
      scrollController: scrollController,
      data: data,
    );
  }
}
