import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/enums/orders.dart';
import 'package:scrapper_filmaffinity/models/filters.dart';
import 'package:scrapper_filmaffinity/providers/top_movies_provider.dart';
import 'package:scrapper_filmaffinity/widgets/card_genre.dart';
import 'package:scrapper_filmaffinity/widgets/platform_item.dart';
import 'package:scrapper_filmaffinity/widgets/year_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late AppLocalizations i18n;
late Filters filters;

class TopMoviesDialog extends StatelessWidget {
  final TopMoviesProvider provider;
  final ScrollController scrollController;

  const TopMoviesDialog(
      {Key? key, required this.provider, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context)!;
    filters = Filters(
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
          const _PlatformsFilter(),
          const _YearsFilter(),
          const SizedBox(
            height: 10,
          ),
          const _GenresFilter(),
          const SizedBox(
            height: 10,
          ),
          const _OrderFilter(),
          const _ExcludeAnimationFilter(),
          _ButtonsFilter(
              provider: provider, scrollController: scrollController),
        ],
      ),
    );
  }
}

class _PlatformsFilter extends StatelessWidget {
  const _PlatformsFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(0, -20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(i18n.title_platforms_dialog,
              style: Theme.of(context).textTheme.headline6),
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: filters.platforms.entries.map((entry) {
                  return PlatformItem(
                      assetName: entry.key,
                      isSelected: entry.value,
                      filters: filters);
                }).toList()),
          ),
        ],
      ),
    );
  }
}

class _YearsFilter extends StatefulWidget {
  const _YearsFilter({Key? key}) : super(key: key);

  @override
  State<_YearsFilter> createState() => _YearsFilterState();
}

class _YearsFilterState extends State<_YearsFilter> {
  bool hasError = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(i18n.title_years_dialog,
              style: Theme.of(context).textTheme.headline6),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            YearContainer(
                year: filters.yearFrom,
                isReverse: false,
                onPressed: setYearFrom),
            const Text('-', style: TextStyle(fontSize: 20)),
            YearContainer(
                year: filters.yearTo, isReverse: true, onPressed: setYearTo),
          ],
        ),
        if (hasError)
          SizedBox(
            height: 20,
            child: Text('* La útlima fecha ha de ser igual o mayor *',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.red, fontStyle: FontStyle.italic)),
          )
        else
          const SizedBox(
            height: 20,
          ),
      ],
    );
  }

  setYearFrom(int year) {
    setState(() {
      filters.yearFrom = year;
    });
  }

  setYearTo(int year) {
    setState(() {
      filters.yearTo = year;
      if (filters.yearFrom > filters.yearTo)
        hasError = true;
      else
        hasError = false;
    });
  }
}

class _GenresFilter extends StatelessWidget {
  const _GenresFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(i18n.title_genres_dialog,
          style: Theme.of(context).textTheme.headline6),
      const SizedBox(height: 10),
      Wrap(
          spacing: 5,
          runSpacing: 5,
          children: filters.genres.entries.map((entry) {
            return CardGenre(
              genre: entry.key,
              isSelected: entry.value,
              filters: filters,
            );
          }).toList()),
    ]);
  }
}

class _OrderFilter extends StatefulWidget {
  const _OrderFilter({Key? key}) : super(key: key);

  @override
  State<_OrderFilter> createState() => _OrderFilterState();
}

class _OrderFilterState extends State<_OrderFilter> {
  final Map<String, String> options = {
    'average': i18n.order_by_average,
    'year': i18n.order_by_year,
    'shuffle': i18n.order_by_shuffle,
  };

  @override
  Widget build(BuildContext context) {
    OrderBy selectedValue = filters.orderBy;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Expanded(
            child: Text(i18n.title_order_by_dialog,
                style: Theme.of(context).textTheme.headline6),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButton<OrderBy>(
              value: selectedValue,
              elevation: 16,
              underline: Container(
                height: 0,
                color: Colors.transparent,
              ),
              onChanged: (OrderBy? newValue) {
                setState(() {
                  selectedValue = newValue!;
                  filters.orderBy = newValue;
                });
              },
              items: OrderBy.values.map((OrderBy value) {
                return DropdownMenuItem<OrderBy>(
                  value: value,
                  child: Text(options[value.value]!),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExcludeAnimationFilter extends StatefulWidget {
  const _ExcludeAnimationFilter({Key? key}) : super(key: key);

  @override
  State<_ExcludeAnimationFilter> createState() =>
      _ExcludeAnimationFilterState();
}

class _ExcludeAnimationFilterState extends State<_ExcludeAnimationFilter> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
        title: Text(i18n.title_exclude_animation_dialog,
            style: Theme.of(context).textTheme.headline6),
        value: filters.isAnimationExcluded,
        activeColor: Colors.orange,
        activeTrackColor: Colors.orange.withOpacity(0.3),
        onChanged: (bool? value) {
          filters.isAnimationExcluded = value!;
          setState(() {
            filters.isAnimationExcluded = value;
          });
        });
  }
}

class _ButtonsFilter extends StatelessWidget {
  final TopMoviesProvider provider;
  final ScrollController scrollController;

  const _ButtonsFilter(
      {Key? key, required this.provider, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localization = AppLocalizations.of(context)!;
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
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
                child: Text(localization.delete_filters_dialog)),
          const SizedBox(width: 10),
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
              child: Text(localization.apply_filters_dialog)),
        ],
      ),
    );
  }
}
