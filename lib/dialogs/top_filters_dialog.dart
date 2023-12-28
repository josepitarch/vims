import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vims/models/enums/genres.dart';
import 'package:vims/models/enums/platforms.dart';
import 'package:vims/models/filters.dart';
import 'package:vims/providers/implementation/top_movies_provider.dart';
import 'package:vims/widgets/card_genre.dart';
import 'package:vims/widgets/platform_item.dart';
import 'package:vims/widgets/year_container.dart';

late AppLocalizations i18n;
late Filters filters;
late bool hasError;

class TopMoviesDialog extends StatelessWidget {
  const TopMoviesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context)!;
    final TopMoviesProvider topMoviesProvider =
        Provider.of<TopMoviesProvider>(context, listen: false);
    hasError = false;

    filters = Filters(
        platforms: [...topMoviesProvider.currentFilters.platforms],
        genres: [...topMoviesProvider.currentFilters.genres],
        isAnimationExcluded:
            topMoviesProvider.currentFilters.isAnimationExcluded,
        yearFrom: topMoviesProvider.currentFilters.yearFrom,
        yearTo: topMoviesProvider.currentFilters.yearTo);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 700, maxWidth: 650),
        color: Colors.black12,
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context, false),
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
                    if (topMoviesProvider.hasFilters) _DeleteButton(),
                    const SizedBox(width: 10),
                    _ApplyButton(),
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
  const _PlatformsFilter();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitleFilter(i18n.title_platforms_dialog),
        const SizedBox(height: 20),
        Container(
          height: height * 0.06,
          constraints: const BoxConstraints(maxHeight: 65),
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: Platforms.values.map((entry) {
                if (entry.showInTopFilters == false)
                  return const SizedBox.shrink();
                return PlatformItem(
                    assetName: entry.name,
                    isSelected: filters.platforms.contains(entry.name),
                    filters: filters);
              }).toList()),
        ),
      ],
    );
  }
}

class _GenresFilter extends StatelessWidget {
  const _GenresFilter();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: double.infinity,
        child: _TitleFilter(i18n.title_genres_dialog),
      ),
      const SizedBox(height: 10),
      Center(
        child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: Genres.values.map((entry) {
              return CardGenre(
                genre: entry.name,
                isSelected: filters.genres.contains(entry.name),
                filters: filters,
              );
            }).toList()),
      ),
    ]);
  }
}

class _YearsFilter extends StatefulWidget {
  const _YearsFilter();

  @override
  State<_YearsFilter> createState() => _YearsFilterState();
}

class _YearsFilterState extends State<_YearsFilter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        _TitleFilter(i18n.title_years_dialog),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
        ),
      ],
    );
  }

  setYearFrom(int year) => setState(() {
        filters.yearFrom = year;
        if (filters.yearFrom > filters.yearTo)
          hasError = true;
        else
          hasError = false;
      });

  setYearTo(int year) => setState(() {
        filters.yearTo = year;
        if (filters.yearFrom > filters.yearTo)
          hasError = true;
        else
          hasError = false;
      });
}

class _ExcludeAnimationFilter extends StatefulWidget {
  const _ExcludeAnimationFilter();

  @override
  State<_ExcludeAnimationFilter> createState() =>
      _ExcludeAnimationFilterState();
}

class _ExcludeAnimationFilterState extends State<_ExcludeAnimationFilter> {
  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).platform == TargetPlatform.android
        ? Colors.orange
        : Colors.green;

    return Column(
      children: [
        _TitleFilter(i18n.title_exclude_dialog),
        SwitchListTile.adaptive(
            contentPadding: const EdgeInsets.all(0),
            dense: true,
            title: Text(i18n.exclude_animation,
                style: Theme.of(context).textTheme.titleLarge),
            value: filters.isAnimationExcluded,
            activeColor: activeColor,
            activeTrackColor: activeColor.withOpacity(0.3),
            onChanged: (bool? value) => setState(() {
                  filters.isAnimationExcluded = value!;
                })),
      ],
    );
  }
}

class _ApplyButton extends StatelessWidget {
  const _ApplyButton();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TopMoviesProvider>(context, listen: false);

    onPressed() {
      if (hasError) return;
      Navigator.pop(context, true);
      provider.applyFilters(filters);
    }

    return Theme.of(context).platform == TargetPlatform.android
        ? MaterialButton(
            elevation: 0,
            color: Colors.orange,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.orange),
                borderRadius: BorderRadius.circular(30)),
            onPressed: onPressed,
            child: Text(i18n.apply_filters_dialog))
        : CupertinoButton(
            onPressed: onPressed,
            child: Text(
              i18n.apply_filters_dialog,
              style: const TextStyle(color: Colors.orange),
            ));
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TopMoviesProvider>(context, listen: false);

    onPressed() {
      Navigator.pop(context, true);
      provider.removeFilters();
    }

    return Theme.of(context).platform == TargetPlatform.android
        ? MaterialButton(
            elevation: 0,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(30)),
            onPressed: onPressed,
            child: Text(i18n.delete_filters_dialog))
        : CupertinoButton(
            onPressed: onPressed,
            child: Text(
              i18n.delete_filters_dialog,
              style: const TextStyle(color: Colors.red),
            ));
  }
}

class _TitleFilter extends StatelessWidget {
  final String title;
  const _TitleFilter(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Flexible(
        child: Divider(
          color: Colors.grey,
          thickness: 1,
        ),
      ),
      const SizedBox(width: 10),
      Text(title, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(width: 10),
      const Flexible(
        child: Divider(
          color: Colors.grey,
          thickness: 1,
        ),
      ),
    ]);
  }
}
