import 'dart:io' as io show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vims/models/enums/type_search_view.dart';
import 'package:vims/providers/implementation/search_movie_provider.dart';
import 'package:vims/ui/input_decoration.dart';
import 'package:vims/widgets/card_movie.dart';
import 'package:vims/widgets/handle_error.dart';
import 'package:vims/widgets/infinite_scroll.dart';
import 'package:vims/widgets/no_results.dart';
import 'package:vims/widgets/shimmer/card_movie_shimmer.dart';

late AppLocalizations i18n;
final TextEditingController _controller = TextEditingController();

class SearchMovieScreen extends StatelessWidget {
  const SearchMovieScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context)!;
    return const SafeArea(
      child:
          Column(children: [_SearchMovieForm(), _TotalSuggestions(), _Body()]),
    );
  }
}

final class _TotalSuggestions extends StatelessWidget {
  const _TotalSuggestions();

  @override
  Widget build(BuildContext context) {
    final SearchMovieProvider provider =
        Provider.of<SearchMovieProvider>(context);
    if (provider.typeSearchView == TypeSearchView.autocomplete)
      return const SizedBox();
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Text('${i18n.total_results}: ${provider.total}',
          style: Theme.of(context).textTheme.headlineMedium!),
    );
  }
}

final class _SearchMovieForm extends StatelessWidget {
  const _SearchMovieForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchMovieProvider>(context, listen: false);
    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: myFormKey,
        child: TextFormField(
          autofocus: false,
          controller: _controller..text = provider.search,
          keyboardType: TextInputType.text,
          enableSuggestions: false,
          keyboardAppearance: Brightness.dark,
          decoration: InputDecorations.searchMovieDecoration(
              i18n, _controller, provider),
          autovalidateMode: AutovalidateMode.disabled,
          validator: (value) {
            if (value!.isEmpty) return i18n.no_empty_search;
            return null;
          },
          onChanged: (value) => provider.onChanged(value),
          onFieldSubmitted: (String value) {
            if (myFormKey.currentState!.validate()) {
              provider.onSubmitted(value);
            }
          },
        ),
      ),
    );
  }
}

final class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchMovieProvider>();
    if (provider.exception != null) {
      return HandleError(provider.exception!, provider.onRefresh);
    }

    if (provider.search.isEmpty) {
      return const _HistorySearch();
    }
    if (provider.isLoading && provider.data!.isEmpty) {
      return const Expanded(child: CardMovieShimmer());
    }
    if (!provider.isLoading && provider.data!.isEmpty) {
      return const NoResults();
    }

    return const _Suggestions();
  }
}

final class _Suggestions extends StatefulWidget {
  const _Suggestions();

  @override
  State<_Suggestions> createState() => _SuggestionsState();
}

class _SuggestionsState extends State<_Suggestions> {
  final ScrollController scrollController = ScrollController();
  late SearchMovieProvider provider;

  @override
  void initState() {
    scrollController.addListener(() {
      final double currentPosition = scrollController.position.pixels;
      final double maxScroll = scrollController.position.maxScrollExtent;
      provider.scrollPosition = currentPosition;

      if (currentPosition + 300 >= maxScroll &&
          !provider.isLoading &&
          provider.hasNextPage) {
        provider.fetchNextPage();
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<SearchMovieProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: InfiniteScroll(data: data, isLoading: provider.isLoading));
  }
}

class _HistorySearch extends StatelessWidget {
  const _HistorySearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchMovieProvider>();
    return FutureBuilder(
        future: provider.getHistorySearchs(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) return const SizedBox();

          List<String> historySearch = snapshot.data as List<String>;

          if (historySearch.isEmpty) {
            return Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  child: Container(color: Colors.transparent),
                ));
          }

          return Expanded(
            child: Column(
              children: [
                ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    shrinkWrap: true,
                    children: [
                      ...historySearch.map((history) {
                        return ListTile(
                          leading: const Icon(Icons.history),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              size: 22, color: Colors.grey),
                          title: Text(history,
                              style: Theme.of(context).textTheme.bodyLarge),
                          onTap: () {
                            _controller.value = TextEditingValue(
                              text: history,
                            );

                            provider.onTapHistorySearch(history);
                          },
                        );
                      }).toList(),
                      DeleteSearchersButton(provider: provider),
                    ]),
                Flexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () =>
                          FocusScope.of(context).requestFocus(FocusNode()),
                      child: Container(color: Colors.transparent),
                    ))
              ],
            ),
          );
        });
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
    return io.Platform.isAndroid
        ? MaterialButton(
            onPressed: () => provider.deleteAllSearchs(),
            child: Text(i18n.delete_all_searchers, style: _textStyle(context)))
        : CupertinoButton(
            child: Text(i18n.delete_all_searchers, style: _textStyle(context)),
            onPressed: () => provider.deleteAllSearchs());
  }

  _textStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.red);
  }
}
