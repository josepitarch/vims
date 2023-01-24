import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vims/dialogs/order_by_dialog.dart';
import 'package:vims/dialogs/top_filters_dialog.dart';
import 'package:vims/enums/mode_views.dart';
import 'package:vims/models/movie.dart';
import 'package:vims/providers/top_movies_provider.dart';
import 'package:vims/shimmer/card_movie_shimmer.dart';
import 'package:vims/widgets/card_movie.dart';
import 'package:vims/widgets/no_results.dart';
import 'package:vims/widgets/handle_error.dart';
import 'package:vims/widgets/title_page.dart';
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
        return HandleError(provider.error!, provider.onRefresh);
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
    final ModeView modeView = provider.modeView;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CupertinoButton(
            child: Text(i18n.title_order_by_dialog,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                textAlign: TextAlign.start),
            onPressed: () => showDialogOrderBy(context)),
        IconButton(
            onPressed: () {
              showDialogFilters(context, provider);
            },
            icon: const Icon(Icons.filter_list_rounded)),
        // IconButton(
        //     icon: Icon(
        //         modeView == ModeView.list ? Icons.apps_rounded : Icons.list),
        //     onPressed: () => setModeView(context, modeView)),
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

  showDialogOrderBy(BuildContext context) {
    return showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => const OrderByDialog());
  }

  setModeView(BuildContext context, ModeView modeView) {
    ModeView newModeView =
        modeView == ModeView.list ? ModeView.grid : ModeView.list;

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
        ? const CardMovieShimmer()
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
