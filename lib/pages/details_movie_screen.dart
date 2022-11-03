import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:diacritic/diacritic.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/database/bookmark_movies_database.dart';

import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/providers/bookmark_movies_provider.dart';
import 'package:scrapper_filmaffinity/providers/homepage_provider.dart';
import 'package:scrapper_filmaffinity/services/metadata_movie_service.dart';
import 'package:scrapper_filmaffinity/ui/box_decoration.dart';
import 'package:scrapper_filmaffinity/utils/flags.dart';
import 'package:scrapper_filmaffinity/widgets/justwatch_item.dart';
import 'package:scrapper_filmaffinity/widgets/review_item.dart';
import 'package:scrapper_filmaffinity/shimmer/details_movie_shimmer.dart';
import 'package:scrapper_filmaffinity/widgets/snackbar.dart';
import 'package:scrapper_filmaffinity/widgets/title_section.dart';

class DetailsMovieScreen extends StatelessWidget {
  const DetailsMovieScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final bool hasAllAttributes = arguments['hasAllAttributes'] ?? false;
    final String id = arguments['id'];

    return FutureBuilder(
        future: !hasAllAttributes
            ? MetadataMovieService().getMetadataMovie(id)
            : Future<Movie>.value(arguments['movie'] as Movie),
        builder: (_, AsyncSnapshot<Movie> snapshot) {
          if (!snapshot.hasData) return const DetailsMovieShimmer();
          Movie movie = snapshot.data!;

          if (!hasAllAttributes) {
            final HomepageProvider homepageProvider =
                Provider.of<HomepageProvider>(context);
            homepageProvider.openedMovies.addAll({movie.id: movie});
          }

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  child: Column(
                    children: [
                      _Header(movie: movie),
                      _Genres(movie.genres),
                      _Cast(cast: movie.cast),
                      _Synopsis(overview: movie.synopsis),
                      _Justwatch(justwatch: movie.justwatch),
                      movie.reviews.isNotEmpty
                          ? _Reviews(movie.reviews)
                          : const SizedBox()
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key, required this.movie}) : super(key: key);

  final Movie movie;
  final double _height = 220;

  @override
  Widget build(BuildContext context) {
    final String director = movie.director ?? '';
    double sizeDirector = director.length > 20 ? 14 : 16;

    return SizedBox(
      height: _height,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Flexible(
          flex: 60,
          child: _Poster(movie: movie, height: _height),
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
                    style: Theme.of(context).textTheme.headline2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    maxLines: 2),
              ),
              if (director.isNotEmpty)
                Text(director,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline5),
              if (director.isNotEmpty)
                const SizedBox(
                  height: 10,
                ),
              _Country(country: movie.country),
              const SizedBox(
                height: 10,
              ),
              Text('${movie.year}  ·  ${transformDuration(movie.duration)}',
                  style: Theme.of(context).textTheme.headline5),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Average(movie: movie),
                      _BookmarkMovie(movie: movie)
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}

transformDuration(String? duration) {
  if (duration == null) return '';
  int total = int.parse(duration.replaceAll(' min.', ''));
  int hours = total ~/ 60;
  int minutes = total % 60;
  String hoursString = hours > 0 ? '$hours H ' : '';
  String minutesString = minutes > 0 ? '$minutes MIN' : '';
  return '$hoursString$minutesString';
}

class _Average extends StatelessWidget {
  const _Average({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Icon(
        Icons.star,
        color: Colors.yellow,
        size: 30,
      ),
      const SizedBox(
        width: 7,
      ),
      Text(
        movie.average.isNotEmpty ? movie.average : '---',
        style: Theme.of(context).textTheme.headline3,
      ),
    ]);
  }
}

class _Country extends StatelessWidget {
  final String country;

  const _Country({
    Key? key,
    required this.country,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String flag = '';
    String countryNormalize = removeDiacritics(country.trim().toLowerCase());

    FlagsAssets.flags.forEach((key, value) {
      if (value.contains(countryNormalize)) {
        flag = key;
      }
    });

    Text text = Text(
      country,
      style: Theme.of(context).textTheme.headline5,
    );
    return flag.isNotEmpty
        ? Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/flags/$flag.png',
                  width: 30,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              text,
            ],
          )
        : text;
  }
}

class _Poster extends StatelessWidget {
  const _Poster({
    Key? key,
    required this.movie,
    required double height,
  })  : _height = height,
        super(key: key);

  final Movie movie;
  final double _height;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: movie.id,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: FadeInImage(
            placeholder: const AssetImage('assets/no-image.jpg'),
            image: NetworkImage(movie.poster),
            height: _height),
      ),
    );
  }
}

class _BookmarkMovie extends StatefulWidget {
  const _BookmarkMovie({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  State<_BookmarkMovie> createState() => _BookmarkMovieState();
}

class _BookmarkMovieState extends State<_BookmarkMovie> {
  late bool isFavorite;

  @override
  void initState() {
    BookmarkMoviesDatabase.getBookmarkMovies().then((value) => setState(() {
          isFavorite = value.any((element) => element.id == widget.movie.id);
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final BookmarkMoviesProvider provider =
        Provider.of<BookmarkMoviesProvider>(context);
    final i18n = AppLocalizations.of(context)!;
    try {
      return Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: IconButton(
                onPressed: () => onPressed(provider, i18n),
                icon: Icon(
                  isFavorite ? Icons.bookmark : Icons.bookmark_border_outlined,
                  size: 25,
                )),
          ));
    } catch (e) {
      return const SizedBox();
    }
  }

  onPressed(BookmarkMoviesProvider provider, AppLocalizations i18n) async {
    Vibrate.canVibrate.then((value) {
      if (value) {
        Vibrate.feedback(FeedbackType.medium);
      }
    });
    bool response = isFavorite
        ? await provider.deleteBookmarkMovie(widget.movie)
        : await provider.insertBookmarkMovie(widget.movie);

    if (response) {
      final String text = isFavorite ? i18n.delete_bookmark : i18n.add_bookmark;
      SnackbarApp snackBar = SnackbarApp(text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      setState(() {
        isFavorite = !isFavorite;
      });
    }
  }
}

class _Genres extends StatelessWidget {
  final List<String> genres;

  const _Genres(this.genres, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 50,
      width: double.infinity,
      child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: genres.map((genre) {
            return Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text(genre,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontWeight: FontWeight.bold))));
          }).toList()),
    );
  }
}

class _Cast extends StatelessWidget {
  const _Cast({Key? key, required this.cast}) : super(key: key);

  final String cast;
  final int _maxLines = 3;

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TitleSection(title: i18n!.cast),
        Text(cast,
            textAlign: TextAlign.start,
            maxLines: _maxLines,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1),
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
    final i18n = AppLocalizations.of(context)!;
    Map<int, String> textButton = {
      0: i18n.see_more,
      1: i18n.see_less,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSection(title: i18n.synopsis),
        Text(widget.overview,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1,
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
  late List<Platform> platforms = [];
  late Map<String, List<Platform>> justwatch;
  late String justwatchMode;

  @override
  void initState() {
    justwatch = widget.justwatch.toMap();
    justwatch.removeWhere((key, value) => value.isEmpty);

    if (justwatch.isNotEmpty) {
      platforms = justwatch.values.first;
      justwatchMode = justwatch.keys.first;
    } else {
      platforms = [];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    Map<String, String> textButton = {
      'flatrate': i18n.flatrate,
      'rent': i18n.rent,
      'buy': i18n.buy,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSection(title: i18n.watch_now),
        if (platforms.isEmpty)
          SizedBox(
            width: double.infinity,
            child: Text(
              i18n.no_platforms,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        if (platforms.isNotEmpty)
          Row(
              children: justwatch.keys.map((key) {
            return Container(
                margin: const EdgeInsets.only(right: 10),
                height: 40,
                decoration: key == justwatchMode
                    ? BoxDecorators.decoratorSelectedButton()
                    : BoxDecorators.decoratorUnselectedButton(),
                child: TextButton(
                    onPressed: () => setPlatforms(key),
                    child: Text(textButton[key]!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.blue))));
          }).toList()),
        if (platforms.isNotEmpty)
          SizedBox(
            height: 60,
            child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(top: 10),
                shrinkWrap: false,
                children: platforms
                    .map((platform) => JustwatchItem(platform: platform))
                    .toList()),
          ),
      ],
    );
  }

  setPlatforms(String platform) {
    if (justwatchMode != platform) {
      justwatchMode = platform;
      platforms = justwatch[platform]!;
      setState(() {});
    }
  }
}

class _Reviews extends StatelessWidget {
  const _Reviews(this.reviews, {Key? key}) : super(key: key);

  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 70.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleSection(title: i18n!.reviews),
          for (final review in reviews)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ReviewItem(review: review),
            )
        ],
      ),
    );
  }
}
