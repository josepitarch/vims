import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:diacritic/diacritic.dart';

import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/utils/flags.dart';
import 'package:scrapper_filmaffinity/utils/justwatch.dart';
import 'package:scrapper_filmaffinity/widgets/justwatch_item.dart';

class MetadataMovieScreen extends StatelessWidget {
  const MetadataMovieScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    try {
      final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Column(
                children: [
                  _Header(movie: movie),
                  _Genres(movie.genres),
                  _Cast(cast: movie.cast),
                  _Synopsis(overview: movie.synopsis),
                  _Justwatch(justwatch: movie.justwatch)
                ],
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      return Center(child: Text(e.toString()));
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key, required this.movie}) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    String flag = '';
    String aux = removeDiacritics(movie.country.trim().toLowerCase());
    FlagsAssets.flags.forEach((key, value) {
      if (value.contains(aux)) {
        flag = key;
      }
    });
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Flexible(
        flex: 60,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(movie.poster),
              height: 220),
        ),
      ),
      Flexible(flex: 5, child: Container()),
      Flexible(
        flex: 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Text(movie.title,
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  maxLines: 2),
            ),
            Text(movie.director, style: const TextStyle(fontSize: 17)),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                if (flag.isNotEmpty)
                  Image.asset(
                    'assets/flags/$flag.png',
                    width: 30,
                    errorBuilder: (_, __, ___) => const Icon(Icons.error),
                  ),
                const SizedBox(
                  width: 10,
                ),
                Text(movie.country),
              ],
            ),
            Text(movie.average)
          ],
        ),
      )
    ]);
  }
}

class _Genres extends StatelessWidget {
  const _Genres(this.genres, {Key? key}) : super(key: key);

  final List<String> genres;
  final int maxGenres = 4;

  @override
  Widget build(BuildContext context) {
    int end = genres.length >= maxGenres ? maxGenres : genres.length;
    List<String> subGenres = genres.sublist(0, end);
    //subGenres.sort((a, b) => a.length.compareTo(b.length));

    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: Wrap(spacing: 10, runSpacing: 10, children: [
          for (final genre in subGenres)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                  color: Colors.blue,
                  width: genre.length > 15 ? 110 : 80,
                  height: 30,
                  child: Center(
                      child: Text(
                    genre,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: genre.length > 15 ? 11 : 12,
                        fontWeight: FontWeight.w500),
                  ))),
            )
        ]),
      ),
    );
  }
}

class _Cast extends StatelessWidget {
  const _Cast({Key? key, required this.cast}) : super(key: key);

  final String cast;
  final int _maxLines = 3;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitleSection(title: localization!.cast),
        Text(cast,
            textAlign: TextAlign.justify,
            maxLines: _maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 17, height: 1.3))
      ],
    );
  }
}

class _Synopsis extends StatefulWidget {
  const _Synopsis({Key? key, required this.overview}) : super(key: key);

  final String overview;
  final int minLines = 5;

  @override
  State<_Synopsis> createState() => _SynopsisState();
}

class _SynopsisState extends State<_Synopsis> {
  int showMore = 0;
  int maxLines = 5;
  final int delimiterLines = 420;

  @override
  void initState() {
    widget.overview.length > delimiterLines
        ? maxLines = widget.minLines
        : maxLines = widget.overview.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    Map<int, String> textButton = {
      0: localization!.see_more,
      1: localization.see_less,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitleSection(title: localization.synopsis),
        Text(widget.overview,
            style: const TextStyle(fontSize: 17, height: 1.3),
            textAlign: TextAlign.justify,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines),
        if (widget.overview.length > delimiterLines)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () => updateState(),
                  child: Text(textButton[showMore]!)),
            ),
          )
      ],
    );
  }

  updateState() {
    if (maxLines == widget.minLines) {
      maxLines = widget.overview.length;
      showMore = 1;
    } else {
      maxLines = widget.minLines;
      showMore = 0;
    }
    setState(() {});
  }
}

class _Justwatch extends StatefulWidget {
  const _Justwatch({Key? key, required this.justwatch}) : super(key: key);

  final Justwatch justwatch;

  @override
  State<_Justwatch> createState() => _JustwatchState();
}

class _JustwatchState extends State<_Justwatch> {
  List<Platform> platforms = [];

  @override
  void initState() {
    platforms = widget.justwatch.flatrate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    const double height = 75;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitleSection(title: localization!.watch_now),
        Row(
          children: [
            if (widget.justwatch.flatrate.isEmpty &&
                widget.justwatch.rent.isEmpty &&
                widget.justwatch.buy.isEmpty)
              Expanded(
                  child: Text(
                localization.no_platforms,
                textAlign: TextAlign.center,
              )),
            if (widget.justwatch.flatrate.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 10),
                child: ElevatedButton(
                    onPressed: () {
                      setPlatforms('flatrate');
                    },
                    child: Text(localization.flatrate)),
              ),
            if (widget.justwatch.rent.isNotEmpty)
              ElevatedButton(
                  onPressed: () {
                    setPlatforms('rent');
                  },
                  child: Text(localization.rent)),
            if (widget.justwatch.buy.isNotEmpty)
              ElevatedButton(
                  onPressed: () {
                    setPlatforms('buy');
                  },
                  child: Text(localization.buy)),
          ],
        ),
        SizedBox(
          height: height,
          child: ListView.builder(
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: platforms.length,
              itemBuilder: (BuildContext context, int index) {
                String name = platforms[index].name;
                String asset = '';
                JustwatchAssets.justwatchAssets.forEach((key, value) {
                  if (value.contains(name.toLowerCase())) {
                    asset = key;
                  }
                });

                return JustwatchItem(asset: asset);
              }),
        ),
      ],
    );
  }

  setPlatforms(String platform) {
    if (platform == 'flatrate') {
      platforms = widget.justwatch.flatrate;
    } else if (platform == 'rent') {
      platforms = widget.justwatch.rent;
    } else if (platform == 'buy') {
      platforms = widget.justwatch.buy;
    }

    setState(() {});
  }
}

class _TitleSection extends StatelessWidget {
  const _TitleSection({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}
