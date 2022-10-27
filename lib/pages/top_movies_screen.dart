import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/enums/genres.dart';
import 'package:scrapper_filmaffinity/enums/orders.dart';
import 'package:scrapper_filmaffinity/models/filters.dart';
import 'package:scrapper_filmaffinity/providers/top_movies_provider.dart';
import 'package:scrapper_filmaffinity/widgets/genre_list_title.dart';
import 'package:scrapper_filmaffinity/shimmer/card_movie_shimmer.dart';
import 'package:scrapper_filmaffinity/widgets/timeout_error.dart';
import 'package:scrapper_filmaffinity/widgets/title_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scrapper_filmaffinity/widgets/year_picker.dart';

import '../widgets/card_movie.dart';

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
        return TimeoutError(onPressed: () => provider.onFresh());
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
                    if (provider.movies.isEmpty)
                      ...List.generate(20, (index) => const CardMovieShimmer())
                    else
                      ...provider.movies.map((movie) => CardMovie(movie: movie))
                  ],
                ))
              ])),
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
    final Filters filters = Filters(
        platforms: Map.from(provider.filters.platforms),
        genres: Map.from(provider.filters.genres),
        isAnimationExcluded: provider.filters.isAnimationExcluded,
        yearFrom: provider.filters.yearFrom,
        yearTo: provider.filters.yearTo);

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
          _PlatformsFilter(filters: filters),
          _YearsFilter(filters: filters),
          _ExcludeAnimationFilter(filters: filters),
          _GenresFilter(filters: filters),
          _ButtonsFilter(provider: provider, filters: filters),
        ],
      ),
    );
  }
}

//ignore: must_be_immutable
class _YearsFilter extends StatefulWidget {
  final Filters filters;

  const _YearsFilter({Key? key, required this.filters}) : super(key: key);

  @override
  State<_YearsFilter> createState() => _YearsFilterState();
}

class _YearsFilterState extends State<_YearsFilter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MaterialButton(
            onPressed: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return YearPickerCupertino(
                        isReverse: false, onItemSelectedChanged: setYearFrom);
                  });
            },
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(30)),
            child: Text(widget.filters.yearFrom.toString())),
        const SizedBox(
          width: 10,
        ),
        MaterialButton(
            onPressed: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return YearPickerCupertino(
                        isReverse: true, onItemSelectedChanged: setYearTo);
                  });
            },
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(30)),
            child: Text(widget.filters.yearTo.toString())),
      ],
    );
  }

  void setYearFrom(int year) {
    setState(() {
      widget.filters.yearFrom = year;
    });
  }

  void setYearTo(int year) {
    setState(() {
      widget.filters.yearTo = year;
    });
  }
}

class _GenresFilter extends StatefulWidget {
  final Filters filters;
  const _GenresFilter({
    Key? key,
    required this.filters,
  }) : super(key: key);

  @override
  State<_GenresFilter> createState() => _GenresFilterState();
}

class _GenresFilterState extends State<_GenresFilter> {
  late String language;
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    language = localization.localeName;
    return Expanded(
        child: ListView(
            children: widget.filters.genres.keys
                .map((key) => GenreListTitle(
                    genre: key.value[localization.localeName]!,
                    isSelected: widget.filters.genres[key]!,
                    onTap: onTap))
                .toList()));
  }

  void onTap(String name) {
    setState(() {
      Genres genre = Genres.getGenre(name, language);
      widget.filters.genres[genre] = !widget.filters.genres[genre]!;
    });
  }
}

class _PlatformsFilter extends StatefulWidget {
  final Filters filters;

  const _PlatformsFilter({Key? key, required this.filters}) : super(key: key);

  @override
  State<_PlatformsFilter> createState() => _PlatformsFilterState();
}

class _PlatformsFilterState extends State<_PlatformsFilter> {
  //TODO: all platforms are rendering when one is selected
  @override
  Widget build(BuildContext context) {
    final List<String> names = widget.filters.platforms.keys.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('¿Qué plataformas tienes?',
            style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 10),
        SizedBox(
          height: 70,
          child: ListView.builder(
              itemCount: widget.filters.platforms.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        bool value = widget.filters.platforms[names[index]]!;
                        widget.filters.platforms[names[index]] = !value;
                      });
                    },
                    child: _PlatformItem(
                        assetName: names[index],
                        isSelected: widget.filters.platforms[names[index]]!),
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
  final Filters filters;
  const _ButtonsFilter(
      {Key? key, required this.provider, required this.filters})
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
                provider.applyFilters(filters);
              },
              child: Text(localization.apply_filters)),
        ],
      ),
    );
  }
}

class _ExcludeAnimationFilter extends StatefulWidget {
  final Filters filters;

  const _ExcludeAnimationFilter({Key? key, required this.filters})
      : super(key: key);

  @override
  State<_ExcludeAnimationFilter> createState() =>
      _ExcludeAnimationFilterState();
}

class _ExcludeAnimationFilterState extends State<_ExcludeAnimationFilter> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return SwitchListTile.adaptive(
        title: Text(localization.exclude_animation),
        value: widget.filters.isAnimationExcluded,
        activeColor: Colors.orange,
        activeTrackColor: Colors.orange.withOpacity(0.3),
        onChanged: (bool? value) {
          widget.filters.isAnimationExcluded = value!;
          setState(() {
            widget.filters.isAnimationExcluded = value;
          });
        });
  }
}
