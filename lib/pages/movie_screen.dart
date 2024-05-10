import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vims/dialogs/create_review_dialog.dart';

import 'package:vims/models/movie.dart';
import 'package:vims/models/review.dart';
import 'package:vims/pages/error/error_screen.dart';
import 'package:vims/providers/implementation/bookmarks_provider.dart';
import 'package:vims/providers/implementation/movie_provider.dart';
import 'package:vims/providers/implementation/reviews_provider.dart';
import 'package:vims/utils/custom_cache_manager.dart';
import 'package:vims/utils/snackbar.dart';
import 'package:vims/widgets/avatar.dart';
import 'package:vims/widgets/country.dart';
import 'package:vims/widgets/custom_image.dart';
import 'package:vims/widgets/justwatch_item.dart';
import 'package:vims/widgets/rating.dart';
import 'package:vims/widgets/review_item.dart';
import 'package:vims/widgets/shimmer/movie_screen_shimmer.dart';

late AppLocalizations i18n;

class MovieScreen extends StatefulWidget {
  final int id;
  final String? heroTag;

  const MovieScreen({required this.id, this.heroTag, super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  late ScrollController scrollController;
  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context)!;
    final provider = Provider.of<MovieProvider>(context);
    final bookmarksProvider =
        Provider.of<BookmarksProvider>(context, listen: false);

    final String heroTag = widget.heroTag ?? widget.id.toString();

    if (provider.exception != null)
      return ErrorScreen(provider.exception!, provider.onRefresh);

    if (provider.data!.containsKey(widget.id) &&
        !provider.isLoading &&
        !bookmarksProvider.isLoading) {
      final Movie movie = provider.data![widget.id]!;
      movie.heroTag = heroTag;
      return screen(provider.data![widget.id]!, scrollController);
    } else {
      provider.fetchMovie(widget.id);
      return const DetailsMovieShimmer();
    }
  }

  Scaffold screen(Movie movie, ScrollController scrollController) {
    final String heroTag = movie.heroTag ?? movie.id.toString();
    return Scaffold(
      body: CustomScrollView(controller: scrollController, slivers: [
        _CustomAppBar(movie.id, movie.title, movie.poster.large, heroTag,
            scrollController),
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _Title(movie.title, movie.originalTitle),
              const SizedBox(height: 7),
              _Director(movie.director),
              Align(alignment: Alignment.center, child: _Box(movie)),
              _YearAndDuration(movie.year, movie.duration),
              _Synopsis(movie.synopsis),
              _Genres(movie.genres),
              _Cast(movie.cast),
              _Platforms(movie.justwatch),
              _Reviews(movie.reviews),
              const SizedBox(height: 10)
            ]),
          )
        ]))
      ]),
    );
  }
}

class _CustomAppBar extends StatefulWidget {
  final int movieId;
  final String title;
  final String url;
  final String heroTag;
  final ScrollController scrollController;

  _CustomAppBar(
      this.movieId, this.title, this.url, this.heroTag, this.scrollController);

  @override
  State<_CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<_CustomAppBar> {
  String auxTitle = '';

  @override
  void initState() {
    auxTitle = '';
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels > 250 && auxTitle.isEmpty) {
        auxTitle = widget.title;
        if (mounted) setState(() {});
      } else if (widget.scrollController.position.pixels <= 250 &&
          auxTitle.isNotEmpty) {
        auxTitle = '';
        if (mounted) setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final icon = Theme.of(context).platform == TargetPlatform.iOS
        ? Icons.arrow_back_ios
        : Icons.arrow_back;

    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.37,
      leading: IconButton(
          icon: Icon(icon),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          }),
      actions: [
        IconButton(
            onPressed: () async {
              await Share.share('https://vims.app/movie/${widget.movieId}',
                  subject: 'Compartir ${widget.title}');
            },
            icon: const Icon(Icons.share))
      ],
      floating: false,
      pinned: true,
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 14, 7, 0),
      title: Text(
        auxTitle,
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
  late BookmarksProvider provider;
  bool isFavorite = false;

  @override
  void initState() {
    provider = context.read<BookmarksProvider>();
    if (FirebaseAuth.instance.currentUser != null) {
      final isBookmark =
          provider.data?.any((element) => element.id == widget.movie.id) ??
              false;

      setState(() {
        isFavorite = isBookmark;
      });
    }
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
      return const SizedBox.shrink();
    }
  }

  onPressed() async {
    if (FirebaseAuth.instance.currentUser == null) {
      SnackBarUtils.show(context, i18n.required_login_bookmark);
      return;
    }
    isFavorite
        ? await provider.removeBookmark(widget.movie.id)
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
                  onTap: () => context.push(
                      '/profile/${actor.id}?name=${actor.name}&image=${actor.image?.mmed}'),
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

    if (platforms.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TitleHeader(i18n.watch_now),
          const _NoStreamingPlatforms(),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitleHeader(i18n.watch_now),
        Row(
            children: justwatch.keys.map((key) {
          return _Button(
              text: textButton[key]!,
              isSelected: key == platformMode,
              onPressed: () => setPlatforms(key));
        }).toList()),
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
    final i18n = AppLocalizations.of(context)!;
    return Column(
      children: [
        _TitleHeader(i18n.reviews),
        Row(children: [
          _Button(
              text: i18n.critic_reviews,
              isSelected: tab == 0,
              onPressed: () => setState(() => tab = 0)),
          _Button(
              text: i18n.user_reviews,
              isSelected: tab == 1,
              onPressed: () => setState(() => tab = 1)),
        ]),
        tab == 0
            ? _CriticReviews(widget.reviews.critics)
            : _UserReviews(widget.reviews.users),
      ],
    );
  }
}

class _CriticReviews extends StatelessWidget {
  final List<CriticReview> criticReviews;
  const _CriticReviews(this.criticReviews);

  @override
  Widget build(BuildContext context) {
    if (criticReviews.isEmpty) {
      return Text(i18n.no_critic_reviews,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontStyle: FontStyle.italic));
    }
    return Column(
        children: criticReviews
            .map((review) => ReviewItem(
                  author: review.author,
                  content: review.content,
                  inclination: review.inclination,
                ))
            .toList());
  }
}

class _UserReviews extends StatelessWidget {
  final List<UserReview> userReviews;
  const _UserReviews(this.userReviews);

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;

    if (userReviews.isEmpty) {
      return Column(children: [
        Text(i18n.no_user_reviews,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!),
        const _WriteReviewButton()
      ]);
    }

    return Column(children: [
      const _WriteReviewButton(),
      ...userReviews.map((review) => ReviewItem(
            author: '',
            createdAt: review.createdAt,
            content: review.content,
            inclination: review.inclination,
          ))
    ]);
  }
}

class _WriteReviewButton extends StatelessWidget {
  const _WriteReviewButton();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;

    onPressed() {
      if (user == null) {
        SnackBarUtils.show(context, i18n.required_login_review);
        return;
      }
      showCupertinoDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => const UserReviewDialog())
          .then((value) {
        if (value != null) {
          final review = UserReview(
              id: -1,
              userId: user.uid,
              movieId: provider.id,
              content: value['content'],
              createdAt: DateTime.now(),
              inclination: value['inclination']);

          provider.createReview(user.uid, provider.id, review).then((review) =>
              context.read<UserReviewsProvider>().data!.add(review));
        }
      });
    }

    return TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            foregroundColor: Colors.grey[400]!,
            elevation: 0,
            textStyle: Theme.of(context).textTheme.bodyLarge),
        icon: const Icon(Icons.rate_review),
        label: Text(i18n.write_review));
  }
}

class _Button extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool isSelected;

  const _Button(
      {required this.text, required this.onPressed, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          backgroundColor:
              isSelected ? MaterialStateProperty.all(Colors.black26) : null),
      onPressed: () => onPressed(),
      child: Text(text,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.orange)),
    );
  }
}

class _NoStreamingPlatforms extends StatelessWidget {
  const _NoStreamingPlatforms();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        i18n.no_platforms,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontStyle: FontStyle.italic),
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
