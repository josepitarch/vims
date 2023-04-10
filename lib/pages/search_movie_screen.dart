import 'dart:io' as io show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vims/models/suggestion.dart';
import 'package:vims/providers/search_movie_provider.dart';
import 'package:vims/shimmer/card_movie_shimmer.dart';
import 'package:vims/ui/input_decoration.dart';
import 'package:vims/widgets/card_suggestion.dart';
import 'package:vims/widgets/handle_error.dart';
import 'package:vims/widgets/no_results.dart';

late AppLocalizations i18n;
late ScrollController scrollController;

class SearchMovieScreen extends StatelessWidget {
  const SearchMovieScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context)!;

    return Consumer<SearchMovieProvider>(builder: (_, provider, __) {
      if (provider.error != null)
        return HandleError(provider.error!, provider.onRefresh);
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
  final int total;
  const _TotalSuggestions(this.total);

  @override
  Widget build(BuildContext context) {
    final text = total == -1 ? '' : 'Total encontrados: $total';
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

    FocusScope.of(context).requestFocus(FocusNode());

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: myFormKey,
        child: TextFormField(
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
              provider.scrollPosition = 0;
              provider.insertHistorySearch(value);
              provider.getSuggestions(value);
            } else {
              return;
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

    return StreamBuilder(
        stream: provider.suggestionsStream,
        builder: (_, AsyncSnapshot<List<Suggestion>> snapshot) {
          if (provider.isLoading)
            return const Expanded(child: CardMovieShimmer());
          if (provider.search.isEmpty) return const _HistorySearch();
          if (!snapshot.hasData && provider.suggestions.isEmpty) {
            return const NoResults();
          }
          List<Suggestion> suggestions = [];
          if (!snapshot.hasData) {
            suggestions = provider.suggestions;
          } else {
            suggestions = snapshot.data!;
          }

          return _Suggestions(suggestions);
        });
  }
}

class _Suggestions extends StatefulWidget {
  const _Suggestions(this.suggestions);

  final List<Suggestion> suggestions;

  @override
  State<_Suggestions> createState() => _SuggestionsState();
}

class _SuggestionsState extends State<_Suggestions> {
  @override
  void initState() {
    final SearchMovieProvider provider =
        Provider.of<SearchMovieProvider>(context, listen: false);
    scrollController =
        ScrollController(initialScrollOffset: provider.scrollPosition);

    scrollController.addListener(() {
      provider.scrollPosition = scrollController.position.pixels;
      if (scrollController.position.pixels + 300 >=
          scrollController.position.maxScrollExtent) {
        if (!provider.isLoading) provider.getSuggestions(provider.search);
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
    final double left = MediaQuery.of(context).size.width * 0.5 - 30;
    return Expanded(
      child: Stack(
        children: [
          ListView.builder(
              controller: scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: widget.suggestions.length,
              itemBuilder: (_, index) {
                final suggestion = widget.suggestions[index];
                return CardSuggestion(suggestion);
              }),
          Positioned(bottom: 10, left: left, child: const SizedBox())
        ],
      ),
    );
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
