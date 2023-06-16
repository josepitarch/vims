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

class SearchMovieScreen extends StatefulWidget {
  const SearchMovieScreen({Key? key}) : super(key: key);

  @override
  State<SearchMovieScreen> createState() => _SearchMovieScreenState();
}

class _SearchMovieScreenState extends State<SearchMovieScreen> {
  late ScrollController scrollController;
  @override
  void initState() {
    final provider = context.read<SearchMovieProvider>();
    scrollController =
        ScrollController(initialScrollOffset: provider.scrollPosition);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context)!;

    return Consumer<SearchMovieProvider>(builder: (_, provider, __) {
      if (provider.exception != null) {
        return HandleError(provider.exception!, provider.onRefresh);
      }

      if (provider.search.isEmpty) {
        const Widget child = _HistorySearch();
        return const _Layout(child: [child]);
      }
      if (provider.isLoading && provider.data == null) {
        const Widget child = Expanded(child: CardMovieShimmer());
        return const _Layout(child: [child]);
      }
      if (!provider.isLoading && provider.data == null) {
        const Widget child = NoResults();
        return const _Layout(child: [child]);
      }

      final Widget suggestions = _Suggestions(
        scrollController: scrollController,
      );

      final List<Widget> child =
          provider.typeSearchView == TypeSearchView.autocomplete
              ? [suggestions]
              : [const _TotalSuggestions(), suggestions];

      return _Layout(child: child);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

class _Layout extends StatelessWidget {
  final List<Widget> child;
  const _Layout({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [const _SearchMovieForm(), ...child])));
  }
}

final class _TotalSuggestions extends StatelessWidget {
  const _TotalSuggestions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchMovieProvider provider = Provider.of(context, listen: false);
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
    final SearchMovieProvider provider = Provider.of(context, listen: false);
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

class _Suggestions extends StatelessWidget {
  final ScrollController scrollController;
  const _Suggestions({required this.scrollController, Key? key})
      : super(key: key);

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

class _HistorySearch extends StatelessWidget {
  const _HistorySearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchMovieProvider provider = Provider.of(context, listen: true);
    return FutureBuilder(
        future: provider.getHistorySearchs(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();

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
