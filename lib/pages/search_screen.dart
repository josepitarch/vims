import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vims/providers/implementation/search_person_provider.dart';
import 'package:vims/providers/implementation/search_movie_provider.dart';
import 'package:vims/providers/implementation/search_provider.dart';
import 'package:vims/ui/input_decoration.dart';
import 'package:vims/widgets/actor_suggestions_tab.dart';
import 'package:vims/widgets/movie_suggestions_tab.dart';

class SearchMovieScreen extends StatelessWidget {
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
            ),
          ),
          body: const TabBarView(children: [
            MovieSuggestionsTab(),
            ActorSuggestionsTab(),
          ]),
        );
      }),
    );
  }
}

final class _SearchMovieForm extends StatelessWidget {
  const _SearchMovieForm();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations i18n = AppLocalizations.of(context)!;
    final SearchProvider provider = Provider.of(context, listen: true);
    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
    final TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: myFormKey,
        child: TextFormField(
          autofocus: false,
          controller: controller,
          keyboardType: TextInputType.text,
          enableSuggestions: false,
          keyboardAppearance: Brightness.dark,
          decoration: InputDecorations.searchMovieDecoration(
              i18n, controller, provider),
          autovalidateMode: AutovalidateMode.disabled,
          validator: (value) {
            if (value!.isEmpty) return '';
            return null;
          },
          onChanged: (value) {
            provider.tabIndex == 0
                ? context.read<SearchMovieProvider>().onChanged(value)
                : context.read<SearchActorProvider>().onChanged(value);
          },
          onFieldSubmitted: (String value) {
            if (myFormKey.currentState!.validate()) {
              controller.text = '';
              provider.tabIndex == 0
                  ? context.read<SearchMovieProvider>().onSubmitted(value)
                  : context.read<SearchActorProvider>().onSubmitted(value);
            }
          },
        ),
      ),
    );
  }
}
