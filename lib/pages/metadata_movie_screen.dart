import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:diacritic/diacritic.dart';

import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/ui/custom_icons.dart';
import 'package:scrapper_filmaffinity/utils/flags.dart';
import 'package:scrapper_filmaffinity/utils/justwatch.dart';

class MetadataMovieScreen extends StatelessWidget {
  const MetadataMovieScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    try {
      final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

      return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              _Header(movie: movie),
              const SizedBox(height: 20),
              _Overview(overview: movie.synopsis),
              _Justwatch(justwatch: movie.justwatch)
            ],
          ),
        )),
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
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(movie.poster),
              height: 220),
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          //color: Colors.red,
          width: 200,
          height: 220,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              child: Text(movie.title,
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  maxLines: 2),
            ),
            const SizedBox(
              height: 15,
            ),
            Text('${movie.director}  ·  ${movie.year}',
                style: const TextStyle(fontSize: 17)),
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
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Puntuación ${movie.average}',
                ),
                IconButton(
                    onPressed: () {}, icon: const Icon(MyIcons.heart_empty))
              ],
            )
          ]),
        )
      ]),
    );
  }
}

class _Overview extends StatefulWidget {
  const _Overview({Key? key, required this.overview}) : super(key: key);

  final String overview;

  @override
  State<_Overview> createState() => _OverviewState();
}

class _OverviewState extends State<_Overview> {
  int showMore = 0;
  final int minLines = 5;
  int maxLines = 5;

  @override
  Widget build(BuildContext context) {
    Map<int, String> textButton = {
      0: AppLocalizations.of(context)!.see_more,
      1: AppLocalizations.of(context)!.see_less,
    };

    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(widget.overview,
                style: const TextStyle(fontSize: 17, height: 1.3),
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
                maxLines: maxLines),
            ElevatedButton(
                onPressed: () => updateState(),
                child: Text(textButton[showMore]!))
          ],
        ));
  }

  updateState() {
    if (maxLines == minLines) {
      maxLines = widget.overview.length;
      showMore = 1;
    } else {
      maxLines = minLines;
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

    return Column(
      children: [
        Row(
          children: [
            if (widget.justwatch.flatrate.isNotEmpty)
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: ElevatedButton(
                    onPressed: () {
                      setPlatforms('flatrate');
                    },
                    child: Text(localization!.flatrate)),
              ),
            if (widget.justwatch.rent.isNotEmpty)
              ElevatedButton(
                  onPressed: () {
                    setPlatforms('rent');
                  },
                  child: Text(localization!.rent)),
            if (widget.justwatch.buy.isNotEmpty)
              ElevatedButton(
                  onPressed: () {
                    setPlatforms('buy');
                  },
                  child: Text(localization!.buy)),
          ],
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
              shrinkWrap: true,
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

                return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    width: 100,
                    height: 100,
                    child: Image.asset(
                      'assets/justwatch/$asset.jpg',
                      width: 100,
                      errorBuilder: (_, __, ___) => const Icon(Icons.error),
                    ));
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
