import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vims/models/actor.dart';
import 'package:vims/models/actor_movie.dart';
import 'package:vims/models/enums/share_page.dart';
import 'package:vims/pages/error/error_screen.dart';
import 'package:vims/providers/implementation/person_profile_provider.dart';
import 'package:vims/services/api/person_service.dart';
import 'package:vims/widgets/avatar.dart';
import 'package:vims/widgets/card_movie.dart';
import 'package:vims/widgets/country.dart';
import 'package:vims/widgets/loading.dart';
import 'package:vims/widgets/no_results.dart';
import 'package:vims/widgets/share_item.dart';
import 'package:vims/widgets/shimmer/card_movie_shimmer.dart';

class PersonScreen extends StatelessWidget {
  final int id;
  String? name;
  final String? image;

  PersonScreen({required this.id, this.name, this.image, super.key});

  @override
  Widget build(BuildContext context) {
    final ActorProfileProvider provider = Provider.of(context, listen: true)
      ..fetchProfile(id);

    if (provider.exception != null) {
      return ErrorScreen(provider.exception!, provider.onRefresh);
    }

    if (provider.isLoading) {
      return Scaffold(
          appBar: AppBar(
            title: Text(name ?? ''),
            actions: [
              ShareItem(
                  subject: name ?? '', sharePage: SharePage.PROFILE, id: id)
            ],
          ),
          body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverToBoxAdapter(
                        child: _Profile(
                      image: image,
                      name: name ?? '',
                    )),
                  ],
              body: const CardMovieShimmer()));
    }

    final Map<Actor, List<ActorMovie>?> data = provider.getActor(id);
    final Actor actor = data.keys.first;
    name = actor.name;
    final List<ActorMovie>? movies = data.values.first;

    final icon = Theme.of(context).platform == TargetPlatform.iOS
        ? Icons.arrow_back_ios
        : Icons.arrow_back;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(icon),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              }),
          title: Text(name!),
          actions: [
            ShareItem(subject: name ?? '', sharePage: SharePage.PROFILE, id: id)
          ],
        ),
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(
                      child: _Profile(
                    image: actor.image?.mmed,
                    name: actor.name,
                    age: actor.age,
                    totalMovies: actor.totalMovies,
                    nacionalities: actor.nacionalities,
                  )),
                ],
            body: Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: _Filmography(id: id, movies: movies),
            )));
  }
}

class _Profile extends StatelessWidget {
  final String? image;
  final String name;
  final int? age;
  final int? totalMovies;
  final List<Nacionality>? nacionalities;

  const _Profile(
      {this.image,
      required this.name,
      this.age,
      this.totalMovies,
      this.nacionalities});

  String buildAgeAndMovies() {
    final String ageAndMovies;
    if (age != null && totalMovies != null) {
      ageAndMovies = '$age años · $totalMovies películas';
    } else if (age != null) {
      ageAndMovies = '$age años';
    } else if (totalMovies != null) {
      ageAndMovies = '$totalMovies películas';
    } else {
      ageAndMovies = '';
    }

    return ageAndMovies;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final String ageAndMovies = buildAgeAndMovies();

    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      width: double.infinity,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AvatarView(image: image, text: name, size: width <= 414 ? 90 : 110),
            const SizedBox(height: 10.0),
            Text(ageAndMovies,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 5.0),
            _Nacionalities(nacionalities: nacionalities ?? [])
          ]),
    );
  }
}

class _Nacionalities extends StatelessWidget {
  final List<Nacionality> nacionalities;
  const _Nacionalities({required this.nacionalities});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: nacionalities
            .map((nacionality) => Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: Country(
                    country: nacionality.name,
                    flag: nacionality.flag,
                  ),
                ))
            .toList());
  }
}

class _Filmography extends StatefulWidget {
  final int id;
  List<ActorMovie>? movies;

  _Filmography({required this.id, this.movies});

  @override
  State<_Filmography> createState() => _FilmographyState();
}

class _FilmographyState extends State<_Filmography> {
  int page = 1;
  int? total;
  int? limit;
  bool hasNextPage = false;
  bool isLoading = false;
  Exception? exception;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    if (widget.movies == null) {
      widget.movies = [];
      fetchData(widget.id, page).then((_) => context
          .read<ActorProfileProvider>()
          .addFirstMoviesPage(widget.id, widget.movies!));
    } else {
      page = 2;
    }
    scrollController.addListener(() {
      final double currentPosition = scrollController.position.pixels;
      final double maxScroll = scrollController.position.maxScrollExtent;

      if (currentPosition + 300 >= maxScroll && !isLoading && hasNextPage) {
        fetchData(widget.id, page);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchData(int id, int page) {
    setState(() {
      isLoading = true;
    });
    getPersonFilmography(id, page).then((value) {
      widget.movies!.addAll(value.results);
      total = value.total;
      limit = value.limit;
      hasNextPage = value.results.length == limit;
      this.page++;
    }).catchError((e) {
      exception = e;
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });

    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    final double left = MediaQuery.of(context).size.width * 0.5 - 20;

    if (exception != null) {
      return ErrorScreen(exception!, () {
        setState(() {
          exception = null;
        });
        fetchData(widget.id, page);
      });
    }

    if (isLoading && widget.movies!.isEmpty) {
      return const CardMovieShimmer();
    }

    if (!isLoading && widget.movies!.isEmpty) {
      return const NoResults();
    }
    return Stack(children: [
      Positioned(
          bottom: 10,
          left: left,
          child: isLoading && widget.movies!.isNotEmpty
              ? const Loading()
              : const SizedBox()),
      ListView(
          controller: scrollController,
          children: widget.movies!
              .map((e) => CardMovie(
                  id: e.id,
                  heroTag: '${e.id.toString()}-${widget.id}',
                  title: e.title,
                  poster: e.poster.mmed,
                  saveToCache: false))
              .toList()),
    ]);
  }
}
