import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/enums/order_item.dart';
import 'package:scrapper_filmaffinity/providers/top_movies_provider.dart';
import 'package:scrapper_filmaffinity/widgets/shimmer/movie_item_shimmer.dart';
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

      return provider.movies.isEmpty
          ? const MovieItemShimmer()
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
  double _height = 200;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 90.0) {
        _height = 0;
        setState(() {});
      } else {
        _height = 200;
        setState(() {});
      }

      if (_scrollController.position.pixels + 100 >
              _scrollController.position.maxScrollExtent &&
          !widget.provider.isLoading) {
        widget.provider.from = widget.provider.to;
        widget.provider.to += 30;
        widget.provider.getTopMovies();
      }
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
                  child: Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                padding: const EdgeInsets.all(8.0),
                child: _FiltersSection(provider: widget.provider),
              ))),
          Expanded(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: widget.provider.movies.length,
                itemBuilder: (_, index) {
                  return MovieItem(
                    movie: widget.provider.movies[index],
                    hasAllAttributes: false,
                  );
                }),
          ),
        ],
      )),
    );
  }
}

class _FiltersSection extends StatelessWidget {
  final TopMoviesProvider provider;
  const _FiltersSection({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      children: [
        _PlatformsFilter(provider: provider),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 10,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(localization.order_by),
              _OrderFilter(provider: provider)
            ],
          ),
        ),
        _ExcludeFilter(provider: provider),
        _ButtonsFilter(provider: provider, localization: localization),
      ],
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
    Map<String, bool> platforms = Map.from(widget.provider.platforms);
    List<String> names = platforms.keys.toList();
    return Column(
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
      ],
    );
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
          child: Text(value.value),
        );
      }).toList(),
    );
  }
}

class _ButtonsFilter extends StatelessWidget {
  const _ButtonsFilter({
    Key? key,
    required this.provider,
    required this.localization,
  }) : super(key: key);

  final TopMoviesProvider provider;
  final AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(
        spacing: 15,
        children: [
          if (provider.hasFilters)
            MaterialButton(
                onPressed: () => provider.removeFilters(),
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(30)),
                child: Text(localization.delete_filters)),
          MaterialButton(
              color: Colors.orange,
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.orange),
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () => provider.applyFilters(),
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
