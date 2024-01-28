import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vims/providers/implementation/search_person_provider.dart';
import 'package:vims/widgets/card_actor.dart';
import 'package:vims/widgets/handle_error.dart';
import 'package:vims/widgets/infinite_scroll.dart';
import 'package:vims/widgets/no_results.dart';
import 'package:vims/widgets/search_history.dart';
import 'package:vims/widgets/shimmer/card_movie_shimmer.dart';
import 'package:vims/widgets/total_suggestions.dart';

class ActorSuggestionsTab extends StatefulWidget {
  const ActorSuggestionsTab({super.key});

  @override
  State<ActorSuggestionsTab> createState() => _ActorSuggestionsTabState();
}

class _ActorSuggestionsTabState extends State<ActorSuggestionsTab> {
  late ScrollController scrollController = ScrollController();
  @override
  void initState() {
    final provider = context.read<SearchActorProvider>();
    provider.data = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SearchActorProvider provider = Provider.of(context, listen: true);

    if (provider.exception != null) {
      return HandleError(provider.exception!, provider.onRefresh);
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
          _ActorSuggestions(
            scrollController: scrollController,
          )
        ]),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          _ActorSuggestions(
            scrollController: scrollController,
          ),
        ],
      ),
    );
  }
}

class _ActorSuggestions extends StatelessWidget {
  final ScrollController scrollController;
  const _ActorSuggestions({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final SearchActorProvider provider = Provider.of(context, listen: false);

    final Widget data = ListView(
        controller: scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children:
            provider.data!.map((actor) => CardActor(actor: actor)).toList());

    return Expanded(
        child: InfiniteScroll(
      provider: provider,
      scrollController: scrollController,
      data: data,
    ));
  }
}
