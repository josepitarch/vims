import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/providers/top_movies_provider.dart';
import 'package:scrapper_filmaffinity/widgets/title_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/movie_item.dart';

class TopMoviesScreen extends StatelessWidget {
  const TopMoviesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TopMoviesProvider>(builder: (_, provider, __) {
      if (provider.existsError) {
        return const Center(
          child: Text('Error'),
        );
      }

      return provider.filteredMovies.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _TopMovies(
              provider: provider,
            );
    });
  }
}

class _TopMovies extends StatefulWidget {
  final TopMoviesProvider provider;
  const _TopMovies({Key? key, required this.provider}) : super(key: key);

  @override
  State<_TopMovies> createState() => _TopMoviesState();
}

class _TopMoviesState extends State<_TopMovies> {
  final _scrollController = ScrollController();
  double _height = 150;

  @override
  void initState() {
    _scrollController.addListener(() {
      _scrollController.position.pixels > 60.0 ? _height = 0 : _height = 150;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitlePage(localization.title_top_movies_page),
          AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: _height,
              child: SingleChildScrollView(
                  child: _PlatformsFilter(provider: widget.provider))),
          Expanded(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: widget.provider.filteredMovies.length,
                itemBuilder: (_, index) {
                  return MovieItem(
                    movie: widget.provider.filteredMovies[index],
                    hasAllAttributes: false,
                  );
                }),
          ),
        ],
      )),
    );
  }
}

class _PlatformsFilter extends StatefulWidget {
  final TopMoviesProvider provider;
  const _PlatformsFilter({Key? key, required this.provider}) : super(key: key);

  @override
  State<_PlatformsFilter> createState() => _PlatformsFilterState();
}

class _PlatformsFilterState extends State<_PlatformsFilter> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    Map<String, bool> platforms = Map.from(widget.provider.platforms);
    List<String> names = platforms.keys.toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 70,
            child: ListView.builder(
                itemCount: widget.provider.platforms.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        widget.provider.setPlatform(names[index]);
                        setState(() {
                          bool value = platforms[names[index]]!;
                          platforms[names[index]] = !value;
                        });
                      },
                      child: Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/justwatch/${names[index]}.jpg',
                            fit: BoxFit.cover,
                            height: 50,
                            errorBuilder: (_, __, ___) => Container(),
                          ),
                        ),
                        if (platforms[names[index]]!)
                          const Positioned(
                              right: 0,
                              bottom: 15,
                              width: 20,
                              height: 20,
                              child: CircleAvatar(
                                  child: Icon(
                                      size: 10,
                                      Icons.check,
                                      color: Colors.white)))
                      ]),
                    ),
                  );
                }),
          ),
          Wrap(
            spacing: 15,
            children: [
              MaterialButton(
                  onPressed: () => widget.provider.removeFilters(),
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(localization.delete_filters)),
              MaterialButton(
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () => widget.provider.applyFilters(),
                  child: Text(localization.apply_filters)),
            ],
          ),
        ],
      ),
    );
  }
}
