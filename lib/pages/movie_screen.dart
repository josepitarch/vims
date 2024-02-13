import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vims/dialogs/user_review_dialog.dart';
import 'package:vims/models/movie.dart';
import 'package:vims/models/review.dart';
import 'package:vims/providers/implementation/bookmark_movies_provider.dart';
import 'package:vims/providers/implementation/movie_provider.dart';
import 'package:vims/ui/box_decoration.dart';
import 'package:vims/utils/custom_cache_manager.dart';
import 'package:vims/utils/snackbar.dart';
import 'package:vims/widgets/avatar.dart';
import 'package:vims/widgets/country.dart';
import 'package:vims/widgets/custom_image.dart';
import 'package:vims/widgets/handle_error.dart';
import 'package:vims/widgets/justwatch_item.dart';
import 'package:vims/widgets/rating.dart';
import 'package:vims/widgets/review_item.dart';
import 'package:vims/widgets/shimmer/movie_screen_shimmer.dart';

late AppLocalizations i18n;

class MovieScreen extends StatelessWidget {
  const MovieScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    i18n = AppLocalizations.of(context)!;
    final provider = Provider.of<MovieProvider>(context);
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final int id = arguments['id'];
    final String heroTag = arguments['heroTag'] ?? id.toString();

    if (provider.exception != null)
      return HandleError(provider.exception!, provider.onRefresh);

    if (provider.data!.containsKey(id)) {
      final Movie movie = provider.data![id]!;
      movie.heroTag = heroTag;
      return screen(provider.data![id]!, scrollController);
    } else {
      provider.fetchMovie(id);
      return const DetailsMovieShimmer();
    }
  }

  Scaffold screen(Movie movie, ScrollController scrollController) {
    final String heroTag = movie.heroTag ?? movie.id.toString();
    return Scaffold(
      body: CustomScrollView(controller: scrollController, slivers: [
        _CustomAppBar(
            movie.title, movie.poster.large, heroTag, scrollController),
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
              _Synopsis(movie.synopsis),
              _Genres(movie.genres),
              _Cast(movie.cast),
              _Platforms(movie.justwatch),
<<<<<<< HEAD
              _Reviews(movie.reviews),
=======
              movie.reviews.critics.isNotEmpty
                  ? _Reviews(movie.reviews.critics)
                  : const SizedBox(),
>>>>>>> main
              const SizedBox(height: 10)
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
  final ScrollController scrollController;

  _CustomAppBar(this.title, this.url, this.heroTag, this.scrollController);

  @override
  State<_CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<_CustomAppBar> {
  @override
  void initState() {
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels > 250)
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
      expandedHeight: MediaQuery.of(context).size.height * 0.37,
      floating: false,
      pinned: true,
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 14, 7, 0),
      title: Text(
        widget.auxTitle,
        style: Theme.of(context).textTheme.displayMedium,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: widget.heroTag,
          child: CustomImage(
              url: widget.url,
              saveToCache: true,
              cacheManager: CustomCacheManager.cacheLargeImages),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }
}

class _Title extends StatelessWidget {
  final String title;
  final String originalTitle;

  const _Title(this.title, this.originalTitle);

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

  const _Director(this.director);

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
  const _Box(this.movie);

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
        Country(country: movie.country, flag: movie.flag),
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

class _BookmarkMovie extends StatefulWidget {
  final Movie movie;

  const _BookmarkMovie(this.movie);

  @override
  State<_BookmarkMovie> createState() => _BookmarkMovieState();
}

class _BookmarkMovieState extends State<_BookmarkMovie> {
  late BookmarkMoviesProvider provider;
  late bool isFavorite;

  @override
  void initState() {
    provider = context.read<BookmarkMoviesProvider>();
    provider.repository.getAllBookmarkMovies().then((value) => setState(() {
          isFavorite = value.any((element) => element.id == widget.movie.id);
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return IconButton(
          iconSize: 27,
          isSelected: isFavorite,
          selectedIcon: const Icon(Icons.bookmark, color: Colors.white),
          onPressed: onPressed,
          icon: const Icon(
            Icons.bookmark_border_outlined,
          ));
    } catch (e) {
      return const SizedBox();
    }
  }

  onPressed() async {
    isFavorite
        ? await provider.deleteBookmarkMovie(widget.movie)
        : await provider.insertBookmarkMovie(widget.movie);

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
  final List<Cast> cast;

  const _Cast(this.cast);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _TitleHeader(i18n.cast),
        (cast.length == 1 && cast[0].id == -1)
            ? Text(cast[0].name, style: Theme.of(context).textTheme.bodyLarge)
            : renderListAvatars(context),
      ],
    );
  }

  SizedBox renderListAvatars(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: width <= 414 ? 120 : 140,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: cast.map((actor) {
            return Container(
              width: width <= 414 ? 65 : 80,
              margin: const EdgeInsets.only(right: 10),
              child: Column(children: [
                AvatarView(
                  text: actor.name,
                  image: actor.image?.mmed,
                  size: width <= 414 ? 65 : 80,
                  borderWidth: 1,
                  borderColor: Colors.grey[200]!,
                  onTap: () {
                    final Map<String, dynamic> arguments = {
                      'id': actor.id,
                      'name': actor.name,
                      'image': actor.image?.mmed,
                    };

                    Navigator.pushNamed(context, 'actor', arguments: arguments);
                  },
                ),
                const SizedBox(height: 5),
                Text(actor.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center)
              ]),
            );
          }).toList()),
    );
  }
}

class _Synopsis extends StatelessWidget {
  final String synopsis;

  const _Synopsis(this.synopsis);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations i18n = AppLocalizations.of(context)!;
    final String text = synopsis.isNotEmpty ? synopsis : i18n.no_synopsis;
    final TextAlign textAlign =
        synopsis.isEmpty ? TextAlign.center : TextAlign.start;

    return Text(text,
        textAlign: textAlign, style: Theme.of(context).textTheme.bodyLarge);
  }
}

class _Platforms extends StatefulWidget {
  final Justwatch justwatch;

  const _Platforms(this.justwatch);

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
    final double widthScreen = MediaQuery.of(context).size.width;
    final double height = widthScreen <= 514 ? 60 : 80;

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                height: 40,
                decoration: key == platformMode
                    ? BoxDecorators.decoratorSelectedButton()
                    : BoxDecorators.decoratorUnselectedButton(),
                child: TextButton(
                    onPressed: () => setPlatforms(key),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 5))),
                    child: Text(textButton[key]!,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.orange[600]!,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w500))));
          }).toList()),
        if (platforms.isNotEmpty)
          SizedBox(
            height: height,
            child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(top: 10),
                shrinkWrap: false,
                children: platforms
                    .map((platform) => JustwatchItem(platform,
                        height: height, width: height - 10))
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

class _Reviews extends StatefulWidget {
  final Review reviews;

  const _Reviews(this.reviews);

  @override
  State<_Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<_Reviews> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TitleHeader(i18n.reviews),
        Row(children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    tab == 0 ? Colors.black26 : Colors.transparent),
            onPressed: () => setState(() => tab = 0),
            child: Text('Críticos',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.orange)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    tab == 1 ? Colors.orange[600] : Colors.transparent),
            onPressed: () => setState(() => tab = 1),
            child: Text('Usuarios',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.orange)),
          ),
        ]),
        tab == 0 ? _CriticReviews(widget.reviews.critics) : _UserReviews(),
      ],
    );
  }
}

class _CriticReviews extends StatelessWidget {
  final List<CriticReview> criticReviews;
  const _CriticReviews(this.criticReviews);

  @override
  Widget build(BuildContext context) {
    return Column(
        children:
            criticReviews.map((review) => ReviewItem(review: review)).toList());
  }
}

class _UserReviews extends StatelessWidget {
  const _UserReviews();

  @override
  Widget build(BuildContext context) {
    //onPresssed with arrow function
    onPressed() {
      // TODO: redirect to login screen
      if (FirebaseAuth.instance.currentUser == null) {
        SnackBarUtils.show(
            context, 'Debes iniciar sesión para escribir una crítica');
        return;
      }
      showCupertinoDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => const UserReviewDialog())
          .then((value) {
        if (value != null) {
          SnackBarUtils.show(context, 'Crítica: $value');
        }
      });
    }

    // TODO

    return Column(children: [
      ElevatedButton(
        onPressed: onPressed,
        child: Text('Escribe una crítica',
            style: TextStyle(color: Colors.orange, fontSize: 18)),
      )
    ]);
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
