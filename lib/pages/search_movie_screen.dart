import 'dart:io' as io show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vims/providers/implementation/search_movie_provider.dart';
import 'package:vims/widgets/shimmer/card_movie_shimmer.dart';
import 'package:vims/ui/input_decoration.dart';
import 'package:vims/widgets/card_movie.dart';
import 'package:vims/widgets/handle_error.dart';
import 'package:vims/widgets/infinite_scroll.dart';
import 'package:vims/widgets/no_results.dart';

late AppLocalizations i18n;
late ScrollController scrollController;

class SearchMovieScreen extends StatelessWidget {
  const SearchMovieScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context)!;

    return Consumer<SearchMovieProvider>(builder: (_, provider, __) {
      if (provider.exception != null)
        return HandleError(provider.exception!, provider.onRefresh);
      return SafeArea(
        child: Column(children: [
          const _SearchMovieForm(),
          _TotalSuggestions(provider.total),
          const _Body()
        ]),
      );
    });
  }
}

class _TotalSuggestions extends StatelessWidget {
  final int? total;
  const _TotalSuggestions(this.total);

  @override
  Widget build(BuildContext context) {
    final text = total == null ? '' : 'Total encontrados: $total';
    return Text(text);
  }
}

class _SearchMovieForm extends StatelessWidget {
  const _SearchMovieForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchMovieProvider>(context);
    final TextEditingController controller = TextEditingController();
    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: myFormKey,
        child: TextFormField(
          autofocus: false,
          controller: controller..text = provider.search,
          keyboardType: TextInputType.text,
          enableSuggestions: false,
          keyboardAppearance: Brightness.dark,
          decoration: InputDecorations.searchMovieDecoration(
              i18n, controller, provider),
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

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchMovieProvider>();

    if (provider.search.isEmpty) return const _HistorySearch();
    if (provider.isLoading && provider.data.isEmpty)
      return const Expanded(child: CardMovieShimmer());
    if (!provider.isLoading && provider.data.isEmpty) return const NoResults();

    return _Suggestions(provider);
  }
}

class _Suggestions extends StatefulWidget {
  final SearchMovieProvider provider;
  const _Suggestions(this.provider);

  @override
  State<_Suggestions> createState() => _SuggestionsState();
}

class _SuggestionsState extends State<_Suggestions> {
  @override
  void initState() {
    scrollController = ScrollController();

    scrollController.addListener(() {
      widget.provider.scrollPosition = scrollController.position.pixels;
      if (scrollController.position.pixels + 300 >=
          scrollController.position.maxScrollExtent) {
        if (!widget.provider.isLoading && widget.provider.hasNextPage)
          widget.provider.fetchNextPage();
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
    final Widget data = ListView(
        controller: scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: widget.provider.data
            .map((suggestion) => CardMovie(
                id: suggestion.id,
                title: suggestion.title,
                poster: suggestion.poster.mmed,
                director: suggestion.director,
                rating: suggestion.rating,
                saveToCache: false))
            .toList());

    return Expanded(
        child:
            InfiniteScroll(data: data, isLoading: widget.provider.isLoading));
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
                          onTap: () => provider.onTapHistorySearch(history),
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
