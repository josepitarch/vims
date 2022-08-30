import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/enums/orders.dart';
import 'package:scrapper_filmaffinity/providers/top_movies_provider.dart';
import 'package:scrapper_filmaffinity/widgets/genre_list_title.dart';
import 'package:scrapper_filmaffinity/widgets/shimmer/movie_item_shimmer.dart';
import 'package:scrapper_filmaffinity/widgets/title_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/movie_item.dart';

class TopMoviesScreen extends StatefulWidget {
  const TopMoviesScreen({Key? key}) : super(key: key);

  @override
  State<TopMoviesScreen> createState() => _TopMoviesScreenState();
}

class _TopMoviesScreenState extends State<TopMoviesScreen> {
  final scrollController = ScrollController();
  bool showFloatingActionButton = false;

  @override
  void initState() {
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
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Consumer<TopMoviesProvider>(builder: (_, provider, __) {
      if (provider.existsError) {
        return const Center(
          child: Text('Error'),
        );
      }

      return Scaffold(
          body: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitlePage(localization.title_top_movies_page),
              Expanded(
                  child: ListView(
                controller: scrollController,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.filter_list_outlined),
                      onPressed: () => showDialogFilters(context, provider),
                    ),
                  ),
                  if (provider.movies.isEmpty)
                    ...List.generate(10, (index) => const MovieItemShimmer())
                  else
                    ...provider.movies.map((movie) => MovieItem(movie: movie)),
                ],
              )),
            ],
          )),
          floatingActionButton: showFloatingActionButton
              ? FloatingActionButton(
                  shape: const CircleBorder(),
                  onPressed: () => scrollController.animateTo(0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut),
                  child: const Icon(Icons.arrow_upward_rounded))
              : null);
    });
  }

  Future<dynamic> showDialogFilters(
      BuildContext context, TopMoviesProvider provider) {
    return showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SafeArea(child: _FiltersSection(provider: provider)),
          );
        });
  }
}

class _FiltersSection extends StatelessWidget {
  final TopMoviesProvider provider;

  const _FiltersSection({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final Map<String, bool> platforms = Map.from(provider.platforms);
    final Map<String, bool> genres = Map.from(provider.genres);
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          _PlatformsFilter(platforms: platforms),
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: Wrap(
          //     spacing: 10,
          //     runAlignment: WrapAlignment.center,
          //     crossAxisAlignment: WrapCrossAlignment.center,
          //     children: [
          //       Text(localization.order_by),
          //       _OrderFilter(provider: provider)
          //     ],
          //   ),
          // ),
          _ExcludeFilter(provider: provider),
          _GenresFilter(genres: genres),
          _ButtonsFilter(
              provider: provider, platforms: platforms, genres: genres),
        ],
      ),
    );
  }
}

class _GenresFilter extends StatefulWidget {
  final Map<String, bool> genres;
  const _GenresFilter({
    Key? key,
    required this.genres,
  }) : super(key: key);

  @override
  State<_GenresFilter> createState() => _GenresFilterState();
}

class _GenresFilterState extends State<_GenresFilter> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
            children: widget.genres.keys
                .map((key) => GenreListTitle(
                    genre: key, isSelected: widget.genres[key]!, onTap: onTap))
                .toList()));
  }

  void onTap(String genre) {
    setState(() {
      widget.genres[genre] = !widget.genres[genre]!;
    });
  }
}

class _PlatformsFilter extends StatefulWidget {
  const _PlatformsFilter({Key? key, required this.platforms}) : super(key: key);

  final Map<String, bool> platforms;

  @override
  State<_PlatformsFilter> createState() => _PlatformsFilterState();
}

class _PlatformsFilterState extends State<_PlatformsFilter> {
  @override
  Widget build(BuildContext context) {
    final List<String> names = widget.platforms.keys.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('¿Qué plataformas tienes?'),
        const SizedBox(height: 10),
        SizedBox(
          height: 70,
          child: ListView.builder(
              itemCount: widget.platforms.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        bool value = widget.platforms[names[index]]!;
                        widget.platforms[names[index]] = !value;
                      });
                    },
                    child: _PlatformItem(
                        assetName: names[index],
                        isSelected: widget.platforms[names[index]]!),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class _PlatformItem extends StatelessWidget {
  const _PlatformItem({
    Key? key,
    required this.assetName,
    required this.isSelected,
  }) : super(key: key);

  final String assetName;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/justwatch/$assetName.jpg',
          fit: BoxFit.cover,
          height: 50,
          errorBuilder: (_, __, ___) => Container(),
        ),
      ),
      if (isSelected)
        const Positioned(
            right: 0,
            bottom: 15,
            width: 20,
            height: 20,
            child: CircleAvatar(
                child: Icon(size: 10, Icons.check, color: Colors.white)))
    ]);
  }
}

class _OrderFilter extends StatefulWidget {
  final TopMoviesProvider provider;
  const _OrderFilter({Key? key, required this.provider}) : super(key: key);

  @override
  State<_OrderFilter> createState() => _OrderFilterState();
}

class _OrderFilterState extends State<_OrderFilter> {
  @override
  Widget build(BuildContext context) {
    OrderItem selectedValue = widget.provider.orderBy;
    return DropdownButton<OrderItem>(
      value: selectedValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.orange,
      ),
      onChanged: (OrderItem? newValue) {
        setState(() {
          selectedValue = newValue!;
          widget.provider.orderBy = newValue;
        });
      },
      items: OrderItem.values.map((OrderItem value) {
        return DropdownMenuItem<OrderItem>(
          value: value,
          child: Text(value.value['en']!),
        );
      }).toList(),
    );
  }
}

class _ButtonsFilter extends StatelessWidget {
  final TopMoviesProvider provider;
  final Map<String, bool> platforms;
  final Map<String, bool> genres;

  const _ButtonsFilter(
      {Key? key,
      required this.provider,
      required this.platforms,
      required this.genres})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localization = AppLocalizations.of(context)!;
    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(
        spacing: 15,
        children: [
          if (provider.hasFilters)
            MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  provider.removeFilters();
                },
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(30)),
                child: Text(localization.delete_filters)),
          MaterialButton(
              color: Colors.orange,
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.orange),
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                Navigator.pop(context);
                provider.applyFilters(platforms, genres);
              },
              child: Text(localization.apply_filters)),
        ],
      ),
    );
  }
}

class _ExcludeFilter extends StatefulWidget {
  final TopMoviesProvider provider;
  const _ExcludeFilter({Key? key, required this.provider}) : super(key: key);

  @override
  State<_ExcludeFilter> createState() => _ExcludeFilterState();
}

class _ExcludeFilterState extends State<_ExcludeFilter> {
  late bool _isExcluded;

  @override
  initState() {
    _isExcluded = widget.provider.excludeAnimation;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
        title: const Text('Exclude animation'),
        value: _isExcluded,
        onChanged: (bool? value) {
          widget.provider.excludeAnimation = value!;
          setState(() {
            _isExcluded = value;
          });
        });
  }
}
