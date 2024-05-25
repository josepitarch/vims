import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vims/pages/error/error_screen.dart';
import 'package:vims/providers/implementation/search_movie_provider.dart';
import 'package:vims/widgets/card_movie.dart';
import 'package:vims/widgets/infinite_scroll.dart';
import 'package:vims/widgets/no_results.dart';
import 'package:vims/widgets/search_history.dart';
import 'package:vims/widgets/shimmer/card_movie_shimmer.dart';
import 'package:vims/widgets/total_suggestions.dart';

class MovieSuggestionsTab extends StatefulWidget {
  const MovieSuggestionsTab({super.key});

  @override
  State<MovieSuggestionsTab> createState() => _MovieSuggestionsTabState();
}

class _MovieSuggestionsTabState extends State<MovieSuggestionsTab> {
  late ScrollController scrollController;
  @override
  void initState() {
    scrollController = ScrollController();
    final provider = context.read<SearchMovieProvider>();
    provider.data = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SearchMovieProvider provider = Provider.of(context, listen: true);
    if (provider.exception != null) {
      return ErrorScreen(provider.exception!, provider.onRefresh);
    }

    if (provider.isLoading && provider.data == null) {
      return const CardMovieShimmer();
    }

    if (provider.data == null) {
      return Column(
        children: [
          HistorySearch(
              future: provider.getHistorySearchs,
              onTap: (String s) => provider.onTapHistorySearch(s),
              onClear: provider.deleteAllSearchs),
        ],
      );
    }
    if (!provider.isLoading && provider.data!.isEmpty) {
      return const NoResults();
    }

    if (provider.total != null) {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(children: [
          TotalSuggestions(total: provider.total!),
          _MovieSuggestions(
            scrollController: scrollController,
          )
        ]),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          _MovieSuggestions(
            scrollController: scrollController,
          ),
        ],
      ),
    );
  }
}

class _MovieSuggestions extends StatelessWidget {
  final ScrollController scrollController;
  const _MovieSuggestions({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final SearchMovieProvider provider = Provider.of(context, listen: false);

    final Widget data = ListView(
        controller: scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: provider.data!
            .map((suggestion) => CardMovie(
                id: suggestion.id,
                title: suggestion.title,
                poster: suggestion.poster.mmed,
                director: suggestion.director,
                rating: suggestion.rating,
                saveToCache: false))
            .toList());

    return Expanded(
        child: InfiniteScroll(
      provider: provider,
      scrollController: scrollController,
      data: data,
    ));
  }
}
