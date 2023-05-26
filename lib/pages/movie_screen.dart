import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';
import 'package:vims/database/bookmark_movies_database.dart';
import 'package:vims/models/movie.dart';
import 'package:vims/providers/implementation/bookmark_movies_provider.dart';
import 'package:vims/providers/implementation/movie_provider.dart';
import 'package:vims/widgets/shimmer/details_movie_shimmer.dart';
import 'package:vims/ui/box_decoration.dart';
import 'package:vims/utils/custom_cache_manager.dart';
import 'package:vims/utils/snackbar.dart';
import 'package:vims/widgets/avatar.dart';
import 'package:vims/widgets/custom_image.dart';
import 'package:vims/widgets/flag.dart';
import 'package:vims/widgets/handle_error.dart';
import 'package:vims/widgets/justwatch_item.dart';
import 'package:vims/widgets/rating.dart';
import 'package:vims/widgets/review_item.dart';

late AppLocalizations i18n;
late ScrollController scrollController;

class MovieScreen extends StatelessWidget {
  const MovieScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context)!;
    scrollController = ScrollController();
    final provider = Provider.of<DetailsMovieProvider>(context, listen: true);
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final int id = arguments['id'];
    final String heroTag = arguments['heroTag'] ?? id.toString();

    if (provider.exception != null)
      return HandleError(provider.exception!, provider.onRefresh);

    if (provider.data.containsKey(id)) {
      final Movie movie = provider.data[id]!;
      movie.heroTag = heroTag;
      return screen(provider.data[id]!);
    } else {
      provider.fetchMovie(id);
      return const DetailsMovieShimmer();
    }
  }

  Scaffold screen(Movie movie) {
    final String heroTag = movie.heroTag ?? movie.id.toString();
    return Scaffold(
      body: CustomScrollView(controller: scrollController, slivers: [
        _CustomAppBar(movie.title, movie.poster.large, heroTag),
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              _Title(movie.title, movie.originalTitle),
              const SizedBox(height: 7),
              _Director(movie.director),
              _Box(movie),
              _YearAndDuration(movie.year, movie.duration),
              _Cast(movie.cast),
              _Genres(movie.genres),
              _Synopsis(movie.synopsis),
              _Platforms(movie.justwatch),
              movie.reviews.isNotEmpty
                  ? _Reviews(movie.reviews)
                  : const SizedBox(),
              const SizedBox(height: 50)
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
      if (scrollController.position.pixels > 250)
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
      expandedHeight: MediaQuery.of(context).size.height * 0.37,
      floating: false,
      pinned: true,
      backgroundColor: const Color.fromARGB(255, 14, 7, 0),
      title: Text(
        widget.auxTitle,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.displayMedium,
      ),
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
  final String originalTitle;
  const _Title(this.title, this.originalTitle, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context).textTheme.displayMedium,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              maxLines: 2),
          const SizedBox(height: 3),
          Text(originalTitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.grey, fontStyle: FontStyle.italic),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              maxLines: 1)
        ],
      ),
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
          style: Theme.of(context).textTheme.headlineSmall),
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
        Rating(movie.rating),
        _BookmarkMovie(movie)
      ]),
    );
  }
}

class _YearAndDuration extends StatelessWidget {
  final int year;
  final String? duration;
  const _YearAndDuration(this.year, this.duration);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      child: Text(year.toString() + transformDuration(duration),
          style: Theme.of(context).textTheme.headlineSmall),
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
          style: Theme.of(context).textTheme.headlineSmall,
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
      _TitleHeader(i18n.genres),
      SizedBox(
        width: double.infinity,
        child: Text(genres.join(', '),
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.start),
      ),
    ]);
  }
}

class _Cast extends StatelessWidget {
  final List<Actor> cast;

  const _Cast(this.cast, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _TitleHeader(i18n.cast),
        SizedBox(
          height: 110,
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: cast.map((actor) {
                final String initials =
                    actor.name.split(' ').map((e) => e[0]).join();
                return SizedBox(
                  width: 78,
                  child: Column(children: [
                    AvatarView(
                      text: initials,
                      imagePath: actor.image ?? '',
                      radius: 32,
                      borderWidth: 1,
                      borderColor: Colors.grey[200]!,
                    ),
                    const SizedBox(height: 5),
                    Text(actor.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center)
                  ]),
                );
              }).toList()),
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
        _TitleHeader(i18n.synopsis),
        SizedBox(
          width: double.infinity,
          child: Text(text,
              textAlign:
                  widget.synopsis.isEmpty ? TextAlign.center : TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: maxLines),
        ),
        if (widget.synopsis.length > delimiterLines)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () => updateState(),
                  child: Text(
                    textButton[showMore]!,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  )),
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

class _Platforms extends StatefulWidget {
  final Justwatch justwatch;

  const _Platforms(this.justwatch, {Key? key}) : super(key: key);

  @override
  State<_Platforms> createState() => _PlatformsState();
}

class _PlatformsState extends State<_Platforms> {
  late List<Platform> platforms = [];
  late Map<String, List<Platform>> justwatch;
  late String platformMode;

  @override
  void initState() {
    justwatch = widget.justwatch.toMap();
    justwatch.removeWhere((key, value) => value.isEmpty);

    if (justwatch.isNotEmpty) {
      platforms = justwatch.values.first;
      platformMode = justwatch.keys.first;
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
        _TitleHeader(i18n.watch_now),
        if (platforms.isEmpty)
          SizedBox(
            width: double.infinity,
            child: Text(
              i18n.no_platforms,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontStyle: FontStyle.italic),
            ),
          ),
        if (platforms.isNotEmpty)
          Row(
              children: justwatch.keys.map((key) {
            return Container(
                margin: const EdgeInsets.only(right: 10),
                height: 40,
                decoration: key == platformMode
                    ? BoxDecorators.decoratorSelectedButton()
                    : BoxDecorators.decoratorUnselectedButton(),
                child: TextButton(
                    onPressed: () => setPlatforms(key),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 12))),
                    child: Text(textButton[key]!,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.blue,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w500))));
          }).toList()),
        if (platforms.isNotEmpty)
          SizedBox(
            height: 60,
            child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(top: 10),
                shrinkWrap: false,
                children: platforms
                    .map((platform) => JustwatchItem(platform))
                    .toList()),
          ),
      ],
    );
  }

  setPlatforms(String platform) {
    if (platformMode != platform) {
      platformMode = platform;
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
          _TitleHeader(i18n.reviews),
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

class _TitleHeader extends StatelessWidget {
  final String title;
  const _TitleHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 15.0, bottom: 7.0),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontFamily: 'OpenSans',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
