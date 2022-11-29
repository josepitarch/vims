import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/database/bookmark_movies_database.dart';

import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/providers/bookmark_movies_provider.dart';
import 'package:scrapper_filmaffinity/providers/details_movie_provider.dart';
import 'package:scrapper_filmaffinity/shimmer/details_movie_shimmer.dart';
import 'package:scrapper_filmaffinity/ui/box_decoration.dart';
import 'package:scrapper_filmaffinity/utils/custom_cache_manager.dart';
import 'package:scrapper_filmaffinity/utils/snackbar.dart';
import 'package:scrapper_filmaffinity/widgets/custom_image.dart';
import 'package:scrapper_filmaffinity/widgets/flag.dart';
import 'package:scrapper_filmaffinity/widgets/justwatch_item.dart';
import 'package:scrapper_filmaffinity/widgets/review_item.dart';
import 'package:scrapper_filmaffinity/widgets/timeout_error.dart';
import 'package:scrapper_filmaffinity/widgets/title_section.dart';

late AppLocalizations i18n;
late ScrollController scrollController;

class DetailsMovieScreen extends StatelessWidget {
  const DetailsMovieScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context)!;
    scrollController = ScrollController();
    final provider = Provider.of<DetailsMovieProvider>(context, listen: true);
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String id = arguments['id'];
    final String heroTag = arguments['heroTag'] ?? id;
    final bool hasAllAttributes = arguments['hasAllAttributes'] ?? false;

    if (provider.error != null) return TimeoutError(provider.error!, provider);

    if (hasAllAttributes) {
      Movie movie = arguments['movie'];
      provider.openedMovies[id] = movie;
      movie.heroTag = heroTag;
      return screen(movie);
    } else if (provider.openedMovies.containsKey(id)) {
      final Movie movie = provider.openedMovies[id]!;
      movie.heroTag = heroTag;
      return screen(provider.openedMovies[id]!);
    } else {
      provider.getDetailsMovie(id);
      return const DetailsMovieShimmer();
    }
  }

  Scaffold screen(Movie movie) {
    return Scaffold(
      /*appBar: AppBar(
          title: Text(movie.title),
          elevation: 0,
          backgroundColor: Colors.black,
          actions: [
            IconButton(icon: const Icon(Icons.share), onPressed: () {})
          ]),*/
      body: CustomScrollView(controller: scrollController, slivers: [
        _CustomAppBar(movie.title, movie.poster, movie.heroTag ?? movie.id),
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              _Title(movie.title),
              const SizedBox(height: 7),
              _Director(movie.director),
              _Box(movie),
              _YearAndDuration(movie.year, movie.duration),
              _Cast(movie.cast),
              _Genres(movie.genres),
              _Synopsis(movie.synopsis),
              _Justwatch(movie.justwatch),
              movie.reviews.isNotEmpty
                  ? _Reviews(movie.reviews)
                  : const SizedBox(),
              const SizedBox(height: 70)
            ]),
          )
        ]))
      ]),
    );
  }
}

class _CustomAppBar extends StatefulWidget {
  final String title;
  final String url;
  final String heroTag;
  String auxTitle = '';

  _CustomAppBar(this.title, this.url, this.heroTag);

  @override
  State<_CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<_CustomAppBar> {
  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels > 270)
        widget.auxTitle = widget.title;
      else
        widget.auxTitle = '';
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: true,
      expandedHeight: MediaQuery.of(context).size.height * 0.40,
      floating: false,
      pinned: true,
      backgroundColor: Colors.black,
      title: Text(widget.auxTitle),
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
            tag: widget.heroTag,
            child: CustomImage(
                url: widget.url,
                width: double.infinity,
                height: double.infinity,
                saveToCache: true,
                cacheManager: CustomCacheManager.cacheLargeImages)),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

class _Title extends StatelessWidget {
  final String title;
  const _Title(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(title,
          style: Theme.of(context).textTheme.headline2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          maxLines: 2),
    );
  }
}

class _Director extends StatelessWidget {
  final String? director;
  const _Director(this.director, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(director ?? '',
          maxLines: 2,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline5),
    );
  }
}

class _Box extends StatelessWidget {
  final Movie movie;
  const _Box(this.movie, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _Country(movie.country, movie.flag),
        _Average(movie.average),
        _BookmarkMovie(movie)
      ]),
    );
  }
}

class _YearAndDuration extends StatelessWidget {
  final String year;
  final String? duration;
  const _YearAndDuration(this.year, this.duration);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      child: Text(year + transformDuration(duration),
          style: Theme.of(context).textTheme.headline5),
    );
  }

  transformDuration(String? duration) {
    if (duration == null) return '';
    int total = int.parse(duration.replaceAll(' min.', ''));
    int hours = total ~/ 60;
    int minutes = total % 60;
    String hoursString = hours > 0 ? '$hours H ' : '';
    String minutesString = minutes > 0 ? '$minutes MIN' : '';

    return '  ·  $hoursString$minutesString';
  }
}

class _Average extends StatelessWidget {
  final String average;

  const _Average(
    this.average, {
    Key? key,
  }) : super(key: key);

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
        average.isNotEmpty ? average : '---',
        style: Theme.of(context).textTheme.headline3,
      ),
    ]);
  }
}

class _Country extends StatelessWidget {
  final String country;
  final String flag;

  const _Country(
    this.country,
    this.flag, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flag(flag: flag, country: country),
        const SizedBox(
          width: 10,
        ),
        Text(
          country,
          style: Theme.of(context).textTheme.headline5,
        )
      ],
    );
  }
}

class _BookmarkMovie extends StatefulWidget {
  final Movie movie;

  const _BookmarkMovie(
    this.movie, {
    Key? key,
  }) : super(key: key);

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
        Provider.of<BookmarkMoviesProvider>(context, listen: false);
    try {
      return IconButton(
          iconSize: 27,
          isSelected: isFavorite,
          selectedIcon: const Icon(Icons.bookmark, color: Colors.white),
          onPressed: () => onPressed(provider),
          icon: const Icon(
            Icons.bookmark_border_outlined,
          ));
    } catch (e) {
      return const SizedBox();
    }
  }

  onPressed(BookmarkMoviesProvider provider) async {
    Vibrate.canVibrate.then((value) {
      if (value) {
        Vibrate.feedback(FeedbackType.medium);
      }
    });
    bool response = isFavorite
        ? await provider.deleteBookmarkMovie(widget.movie)
        : await provider.insertBookmarkMovie(widget.movie);

    if (response) {
      Map<String, List<String>> snackbarI18n = {
        'movie': [i18n.add_movie_bookmark, i18n.delete_movie_bookmark],
        'serie': [i18n.add_serie_bookmark, i18n.delete_serie_bookmark]
      };
      String text = '';
      if (widget.movie.title.toLowerCase().contains('serie')) {
        text = snackbarI18n['serie']![isFavorite ? 1 : 0];
      } else {
        text = snackbarI18n['movie']![isFavorite ? 1 : 0];
      }

      if (mounted) SnackBarUtils.show(context, text);

      setState(() {
        isFavorite = !isFavorite;
      });
    }
  }
}

class _Genres extends StatelessWidget {
  final List<String> genres;
  const _Genres(this.genres);

  @override
  Widget build(BuildContext context) {
    String genresString = genres.join(', ');
    genresString = genresString[0] + genresString.substring(1).toLowerCase();

    return Column(children: [
      TitleSection(
        title: i18n.genres,
      ),
      SizedBox(
        width: double.infinity,
        child: Text(genres.join(', '),
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.start),
      ),
    ]);
  }

  String transformGenres(List<String> genres) {
    List<String> genresTransformed = [];
    genres.forEach((element) {
      if (element.startsWith('I') && element.toLowerCase().contains('guerra'))
        genresTransformed.add(element);
      else
        genresTransformed.add(element[0].toLowerCase() + element.substring(1));
    });

    if (genresTransformed.isNotEmpty) {
      genresTransformed[0] = genresTransformed[0][0].toUpperCase() +
          genresTransformed[0].substring(1);
    }
    return genresTransformed.join(', ');
  }
}

class _Cast extends StatelessWidget {
  final List<Actor> cast;

  const _Cast(this.cast, {Key? key}) : super(key: key);

  final int _maxLines = 3;

  @override
  Widget build(BuildContext context) {
    final text = cast.map((e) => e.name).join(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TitleSection(title: i18n.cast),
        SizedBox(
          width: double.infinity,
          child: Text(cast.isNotEmpty ? text : i18n.no_cast,
              textAlign: cast.isNotEmpty ? TextAlign.start : TextAlign.center,
              maxLines: _maxLines,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1),
        ),
      ],
    );
  }
}

class _Synopsis extends StatefulWidget {
  final String synopsis;

  const _Synopsis(this.synopsis, {Key? key}) : super(key: key);

  @override
  State<_Synopsis> createState() => _SynopsisState();
}

class _SynopsisState extends State<_Synopsis> {
  final int minLines = 5;
  int showMore = 0;
  int maxLines = 5;
  final int delimiterLines = 420;
  late String text;

  @override
  void initState() {
    text = widget.synopsis.isNotEmpty ? widget.synopsis : i18n.no_synopsis;
    text.length > delimiterLines ? maxLines = minLines : maxLines = text.length;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<int, String> textButton = {
      0: i18n.see_more,
      1: i18n.see_less,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSection(title: i18n.synopsis),
        SizedBox(
          width: double.infinity,
          child: Text(text,
              textAlign:
                  widget.synopsis.isEmpty ? TextAlign.center : TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
              maxLines: maxLines),
        ),
        if (widget.synopsis.length > delimiterLines)
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
    if (maxLines == minLines) {
      maxLines = widget.synopsis.length;
      showMore = 1;
    } else {
      maxLines = minLines;
      showMore = 0;
    }
    setState(() {});
  }
}

class _Justwatch extends StatefulWidget {
  final Justwatch justwatch;

  const _Justwatch(this.justwatch, {Key? key}) : super(key: key);

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
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleSection(title: i18n.reviews),
          ...reviews
              .map((review) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ReviewItem(review: review)))
              .toList(),
        ],
      ),
    );
  }
}
