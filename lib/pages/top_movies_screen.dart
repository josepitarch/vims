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

    return Consumer<TopMoviesProvider>(builder: (_, provider, __) {
      if (provider.exception != null) {
        return HandleError(provider.exception!, provider.onRefresh);
      }

      if (provider.isLoading && provider.data == null) {
        const Widget body = Expanded(child: CardMovieShimmer());
        return const _Layout(body: [body]);
      }

      if (!provider.isLoading && provider.data!.isEmpty) {
        final List<Widget> body = [
          _Options(scrollController: scrollController),
          const NoResults(),
        ];
        return _Layout(body: body);
      }

      final List<Widget> child = [
        _Options(scrollController: scrollController),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.685,
            child: _TopMovies(scrollController: scrollController))
      ];

      return _Layout(
          floatingActionButton: showFloatingActionButton
              ? _FloatingActionButton(scrollController: scrollController)
              : null,
          body: child);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

class _Layout extends StatelessWidget {
  final List<Widget> body;
  final Widget? floatingActionButton;

  const _Layout({required this.body, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [TitlePage(i18n.title_top_movies_page), ...body])),
        floatingActionButton: floatingActionButton);
  }
}

class _Options extends StatelessWidget {
  final ScrollController scrollController;

  const _Options({required this.scrollController});

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
                heroTag: movie.id.toString(),
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
