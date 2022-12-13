import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/models/filters.dart';
import 'package:scrapper_filmaffinity/providers/top_movies_provider.dart';
import 'package:scrapper_filmaffinity/widgets/card_genre.dart';
import 'package:scrapper_filmaffinity/widgets/platform_item.dart';
import 'package:scrapper_filmaffinity/widgets/year_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io' as io show Platform;

late AppLocalizations i18n;
late Filters filters;
late TopMoviesProvider provider;
late ScrollController scrollController;

class TopMoviesDialog extends StatelessWidget {
  final TopMoviesProvider topMoviesProvider;
  final ScrollController controller;

  const TopMoviesDialog(
      {Key? key, required this.topMoviesProvider, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context)!;
    provider = topMoviesProvider;
    scrollController = controller;
    filters = Filters(
        platforms: Map.from(topMoviesProvider.filters.platforms),
        genres: Map.from(topMoviesProvider.filters.genres),
        isAnimationExcluded: topMoviesProvider.filters.isAnimationExcluded,
        yearFrom: topMoviesProvider.filters.yearFrom,
        yearTo: topMoviesProvider.filters.yearTo);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 650,
        width: double.infinity,
        child: SizedBox(
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
              const SizedBox(
                height: 10,
              ),
              const _GenresFilter(),
              const SizedBox(
                height: 10,
              ),
              const _YearsFilter(),
              const _ExcludeAnimationFilter(),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (provider.hasFilters) const _DeleteButton(),
                    const SizedBox(width: 10),
                    const _ApplyButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlatformsFilter extends StatelessWidget {
  const _PlatformsFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

class _GenresFilter extends StatelessWidget {
  const _GenresFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: double.infinity,
        child: Text(i18n.title_genres_dialog,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headline6),
      ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            YearContainer(
                year: filters.yearFrom,
                isReverse: false,
                onPressed: setYearFrom),
            const SizedBox(width: 30),
            YearContainer(
                year: filters.yearTo,
                isReverse: true,
                onPressed: setYearTo,
                hasError: hasError),
          ],
        ),
      ],
    );
  }

  setYearFrom(int year) => setState(() => filters.yearFrom = year);

  setYearTo(int year) => setState(() {
        filters.yearTo = year;
        if (filters.yearFrom > filters.yearTo)
          hasError = true;
        else
          hasError = false;
      });
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
    final activeColor = io.Platform.isAndroid ? Colors.orange : Colors.green;

    return SwitchListTile.adaptive(
        contentPadding: const EdgeInsets.all(0),
        dense: true,
        title: Text(i18n.title_exclude_animation_dialog,
            style: Theme.of(context).textTheme.headline6),
        value: filters.isAnimationExcluded,
        activeColor: activeColor,
        activeTrackColor: activeColor.withOpacity(0.3),
        onChanged: (bool? value) => setState(() {
              filters.isAnimationExcluded = value!;
            }));
  }
}

class _ApplyButton extends StatelessWidget {
  const _ApplyButton();

  @override
  Widget build(BuildContext context) {
    return io.Platform.isAndroid
        ? MaterialButton(
            elevation: 0,
            color: Colors.orange,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.orange),
                borderRadius: BorderRadius.circular(30)),
            onPressed: () {
              if (scrollController.hasClients) scrollController.jumpTo(0);
              provider.applyFilters(filters);
              Navigator.pop(context);
            },
            child: Text(i18n.apply_filters_dialog))
        : CupertinoButton(
            borderRadius: BorderRadius.circular(30),
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            color: Colors.orange,
            onPressed: () {
              if (scrollController.hasClients) scrollController.jumpTo(0);
              provider.applyFilters(filters);
              Navigator.pop(context);
            },
            child: Text(i18n.apply_filters_dialog));
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton();

  @override
  Widget build(BuildContext context) {
    return io.Platform.isAndroid
        ? MaterialButton(
            elevation: 0,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(30)),
            onPressed: () {
              if (scrollController.hasClients) scrollController.jumpTo(0);
              Navigator.pop(context);
              provider.removeFilters();
            },
            child: Text(i18n.delete_filters_dialog))
        : CupertinoButton(
            borderRadius: BorderRadius.circular(30),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            color: Colors.red,
            onPressed: () {
              if (scrollController.hasClients) scrollController.jumpTo(0);
              Navigator.pop(context);
              provider.removeFilters();
            },
            child: Text(i18n.delete_filters_dialog));
  }
}
