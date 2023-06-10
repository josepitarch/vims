import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vims/dialogs/top_filters_dialog.dart';
import 'package:vims/providers/implementation/top_movies_provider.dart';
import 'package:vims/widgets/card_movie.dart';
import 'package:vims/widgets/handle_error.dart';
import 'package:vims/widgets/infinite_scroll.dart';
import 'package:vims/widgets/no_results.dart';
import 'package:vims/widgets/shimmer/card_movie_shimmer.dart';
import 'package:vims/widgets/title_page.dart';

late AppLocalizations i18n;

class TopMoviesScreen extends StatefulWidget {
  const TopMoviesScreen({Key? key}) : super(key: key);

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
      final double maxScrollPosition =
          scrollController.position.maxScrollExtent;
      provider.scrollPosition = currentScrollPosition;
      if (currentScrollPosition >= limitShowFab && !showFloatingActionButton) {
        setState(() => showFloatingActionButton = true);
      } else if (currentScrollPosition < limitShowFab &&
          showFloatingActionButton) {
        setState(() => showFloatingActionButton = false);
      }
      if (currentScrollPosition + 300 >= maxScrollPosition) {
        if (!provider.isLoading && provider.hasNextPage)
          provider.fetchNextPage();
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
      if (provider.exception != null) {
        return HandleError(provider.exception!, provider.onRefresh);
      }

      return Scaffold(
          body: SafeArea(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                TitlePage(i18n.title_top_movies_page),
                _Options(scrollController: scrollController),
                (!provider.isLoading && provider.data!.isEmpty)
                    ? const NoResults()
                    : Expanded(
                        child: _Body(scrollController: scrollController)),
              ])),
          floatingActionButton: showFloatingActionButton
              ? _FloatingActionButton(scrollController: scrollController)
              : null);
    });
  }
}

class _Options extends StatelessWidget {
  final ScrollController scrollController;
  const _Options({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final ModeView modeView = provider.modeView;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // IconButton(
        //     icon: Icon(
        //         modeView == ModeView.list ? Icons.list : Icons.apps_rounded),
        //     onPressed: () => provider.setModeView()),
        IconButton(
            onPressed: () {
              showDialogFilters(context);
            },
            icon: const Icon(Icons.filter_list_rounded)),
      ],
    );
  }

  jumpToTop() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
  }

  showDialogFilters(BuildContext context) {
    return showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) =>
            TopMoviesDialog(jumpToTop: jumpToTop));
  }
}

class _FloatingActionButton extends StatelessWidget {
  final ScrollController scrollController;
  const _FloatingActionButton({
    required this.scrollController,
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
  final ScrollController scrollController;
  const _Body({required this.scrollController, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TopMoviesProvider provider = context.watch<TopMoviesProvider>();
    if (provider.isLoading && provider.data!.isEmpty) {
      return const CardMovieShimmer();
    }

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

    return InfiniteScroll(data: data, isLoading: provider.isLoading);
  }
}
