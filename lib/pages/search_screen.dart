import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vims/providers/implementation/search_movie_provider.dart';
import 'package:vims/providers/implementation/search_person_provider.dart';
import 'package:vims/providers/implementation/search_provider.dart';
import 'package:vims/ui/input_decoration.dart';
import 'package:vims/widgets/actor_suggestions_tab.dart';
import 'package:vims/widgets/movie_suggestions_tab.dart';

final class SearchMovieScreen extends StatelessWidget {
  const SearchMovieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchProvider provider = Provider.of(context, listen: false);
    const List<Tab> tabs = <Tab>[
      Tab(icon: Icon(Icons.movie)),
      Tab(icon: Icon(Icons.person)),
    ];

    return DefaultTabController(
      length: tabs.length,
      initialIndex: provider.tabIndex,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            provider.setTabIndex(tabController.index);
          }
        });
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 85,
            flexibleSpace: const SafeArea(
              child: _SearchMovieForm(),
            ),
            bottom: const TabBar(
              tabs: tabs,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: const TabBarView(children: [
              MovieSuggestionsTab(),
              ActorSuggestionsTab(),
            ]),
          ),
        );
      }),
    );
  }
}

final class _SearchMovieForm extends StatelessWidget {
  const _SearchMovieForm();

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final i18n = AppLocalizations.of(context)!;
    final SearchProvider provider = Provider.of(context, listen: true);

    clearText() {
      if (controller.text.isNotEmpty) {
        controller.text = '';
      }
    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
          autofocus: false,
          controller: controller,
          keyboardType: TextInputType.text,
          enableSuggestions: true,
          keyboardAppearance: Brightness.dark,
          decoration:
              InputDecorations.searchDecoration(i18n, clearText, provider),
          onChanged: (value) {
            provider.tabIndex == 0
                ? context.read<SearchMovieProvider>().onChanged(value)
                : context.read<SearchActorProvider>().onChanged(value);
          },
          onSubmitted: (String value) {
            controller.text = '';
            provider.tabIndex == 0
                ? context.read<SearchMovieProvider>().onSubmitted(value)
                : context.read<SearchActorProvider>().onSubmitted(value);
          }),
    );
  }
}
