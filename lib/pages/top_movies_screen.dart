import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/enums/orders.dart';
import 'package:scrapper_filmaffinity/models/filters.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/providers/top_movies_provider.dart';
import 'package:scrapper_filmaffinity/shimmer/card_movie_shimmer.dart';
import 'package:scrapper_filmaffinity/widgets/card_genre.dart';
import 'package:scrapper_filmaffinity/widgets/card_movie.dart';
import 'package:scrapper_filmaffinity/widgets/platform_item.dart';
import 'package:scrapper_filmaffinity/widgets/timeout_error.dart';
import 'package:scrapper_filmaffinity/widgets/title_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scrapper_filmaffinity/widgets/year_picker.dart';

class TopMoviesScreen extends StatefulWidget {
  const TopMoviesScreen({Key? key}) : super(key: key);

  @override
  State<TopMoviesScreen> createState() => _TopMoviesScreenState();
}

class _TopMoviesScreenState extends State<TopMoviesScreen> {
  List<Movie> movies = [];
  late TopMoviesProvider topMoviesProvider;
  final scrollController = ScrollController();
  bool showFloatingActionButton = false;
  late int totalMovies;
  int pagination = 30;

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

      if (scrollController.position.pixels + 200 >=
              scrollController.position.maxScrollExtent &&
          pagination <= totalMovies &&
          movies.isNotEmpty) {
        setState(() {
          movies.addAll(
              topMoviesProvider.movies.sublist(movies.length, pagination));
          pagination += 20;
        });
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
    final localization = AppLocalizations.of(context)!;

    return Consumer<TopMoviesProvider>(builder: (_, provider, __) {
      topMoviesProvider = provider;
      if (provider.existsError) {
        return TimeoutError(onPressed: () => provider.onFresh());
      }

      if (movies.isEmpty && !provider.isLoading && !provider.existsError) {
        totalMovies = provider.movies.length;
        movies = provider.movies.sublist(0, 30);
      }

      return Scaffold(
          body: SafeArea(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                TitlePage(localization.title_top_movies_page),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () {
                        pagination = 30;
                        movies.clear();
                        showDialogFilters(context, provider, scrollController);
                      },
                      icon: const Icon(Icons.filter_list_rounded)),
                ),
                Expanded(
                    child: ListView(
                  controller: scrollController,
                  children: [
                    if (movies.isEmpty)
                      ...List.generate(20, (index) => const CardMovieShimmer())
                    else
                      ...movies.map((movie) => CardMovie(movie: movie))
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

  Future<dynamic> showDialogFilters(BuildContext context,
      TopMoviesProvider provider, ScrollController scrollController) {
    return showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: _FiltersSection(
                provider: provider, scrollController: scrollController),
          );
        });
  }
}

class _FiltersSection extends StatelessWidget {
  final TopMoviesProvider provider;
  final ScrollController scrollController;

  const _FiltersSection(
      {Key? key, required this.provider, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Filters filters = Filters(
        platforms: Map.from(provider.filters.platforms),
        genres: Map.from(provider.filters.genres),
        orderBy: provider.filters.orderBy,
        isAnimationExcluded: provider.filters.isAnimationExcluded,
        yearFrom: provider.filters.yearFrom,
        yearTo: provider.filters.yearTo);

    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 600,
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
          _OrderFilter(filters: filters),
          _ExcludeAnimationFilter(filters: filters),
          _GenresFilter(filters: filters),
          _ButtonsFilter(
              provider: provider,
              filters: filters,
              scrollController: scrollController),
        ],
      ),
    );
  }
}

class _PlatformsFilter extends StatelessWidget {
  final Filters filters;

  const _PlatformsFilter({Key? key, required this.filters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('¿Qué plataformas tienes?',
            style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 10),
        SizedBox(
          height: 60,
          child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: false,
              children: filters.platforms.entries.map((entry) {
                return PlatformItem(
                    assetName: entry.key,
                    isSelected: entry.value,
                    filters: filters);
              }).toList()),
        ),
      ],
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

class _GenresFilter extends StatelessWidget {
  final Filters filters;
  const _GenresFilter({
    Key? key,
    required this.filters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Wrap(
          spacing: 5,
          runSpacing: 5,
          children: filters.genres.entries.map((entry) {
            return CardGenre(
              genre: entry.key,
              isSelected: entry.value,
              filters: filters,
            );
          }).toList()),
    );
  }
}

class _OrderFilter extends StatefulWidget {
  final Filters filters;
  const _OrderFilter({Key? key, required this.filters}) : super(key: key);

  @override
  State<_OrderFilter> createState() => _OrderFilterState();
}

class _OrderFilterState extends State<_OrderFilter> {
  @override
  Widget build(BuildContext context) {
    OrderBy selectedValue = widget.filters.orderBy;
    return DropdownButton<OrderBy>(
      value: selectedValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.orange,
      ),
      onChanged: (OrderBy? newValue) {
        setState(() {
          selectedValue = newValue!;
          widget.filters.orderBy = newValue;
        });
      },
      items: OrderBy.values.map((OrderBy value) {
        return DropdownMenuItem<OrderBy>(
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
  final ScrollController scrollController;

  const _ButtonsFilter(
      {Key? key,
      required this.provider,
      required this.filters,
      required this.scrollController})
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
                scrollController.jumpTo(0);
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
