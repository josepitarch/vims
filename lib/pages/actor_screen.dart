import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vims/models/actor.dart';
import 'package:vims/models/actor_movie.dart';
import 'package:vims/providers/implementation/actor_filmography_provider.dart';
import 'package:vims/providers/implementation/actor_profile_provider.dart';
import 'package:vims/widgets/avatar.dart';
import 'package:vims/widgets/card_movie.dart';
import 'package:vims/widgets/country.dart';
import 'package:vims/widgets/handle_error.dart';
import 'package:vims/widgets/infinite_scroll.dart';
import 'package:vims/widgets/loading.dart';

class ActorScreen extends StatefulWidget {
  const ActorScreen({super.key});

  @override
  State<ActorScreen> createState() => _ActorScreenState();
}

class _ActorScreenState extends State<ActorScreen> {
  late ScrollController scrollController;
  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int id = arguments['id'];

    final ActorProfileProvider provider = Provider.of(context, listen: true)
      ..fetchProfile(id);

    if (provider.exception != null) {
      return HandleError(provider.exception!, provider.onRefresh);
    }

    if (provider.isLoading) {
      return _Layout(
          scrollController: scrollController,
          sliverAppBarBackground: _Profile(
            image: arguments['image'],
            age: null,
            totalMovies: null,
            country: null,
          ),
          sliverAppBarTitle: arguments['name'],
          body: UnconstrainedBox(
            child: SizedBox(height: height * 0.5, child: const Loading()),
          ));
    }

    final Map<Actor, List<ActorMovie>?> data = provider.getActor(id);
    final Actor actor = data.keys.first;
    final List<ActorMovie>? movies = data.values.first;

    return _Layout(
        scrollController: scrollController,
        sliverAppBarBackground: _Profile(
          image: actor.image?.mmed,
          age: actor.age,
          totalMovies: actor.totalMovies,
          country: actor.nacionality,
        ),
        sliverAppBarTitle: arguments['name'],
        body: _Filmography(
            scrollController: scrollController, firstPage: movies));
  }
}

class _Layout extends StatelessWidget {
  final ScrollController scrollController;
  final String sliverAppBarTitle;
  final Widget sliverAppBarBackground;
  final Widget body;
  const _Layout(
      {required this.scrollController,
      required this.body,
      required this.sliverAppBarBackground,
      required this.sliverAppBarTitle,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(controller: scrollController, slivers: [
      SliverAppBar(
        expandedHeight: MediaQuery.of(context).size.height * 0.23,
        floating: false,
        pinned: true,
        backgroundColor: Colors.grey[900],
        elevation: 0.0,
        flexibleSpace: FlexibleSpaceBar(
            title: Text(
              sliverAppBarTitle,
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            background: sliverAppBarBackground),
      ),
      SliverList(delegate: SliverChildListDelegate([body]))
    ]));
  }
}

class _Profile extends StatelessWidget {
  final String? image;
  final String? age;
  final int? totalMovies;
  final String? country;
  const _Profile(
      {this.image, this.age, this.totalMovies, this.country, super.key});

  @override
  Widget build(BuildContext context) {
    final imagePath = image != null ? image! : '';
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.only(left: 60.0, top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarView(imagePath: imagePath, radius: 50),
          const SizedBox(width: 10.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(age != null ? age! : '',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 10.0),
              Text(totalMovies != null ? '$totalMovies películas' : '',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 10.0),
              if (country != null) Country(country: country!),
            ],
          ),
        ],
      ),
    ));
  }
}

class _Filmography extends StatelessWidget {
  final ScrollController scrollController;
  final List<ActorMovie>? firstPage;
  const _Filmography(
      {required this.scrollController, this.firstPage, super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int id = arguments['id'];
    final int page = firstPage == null ? 1 : 2;
    return ChangeNotifierProvider(
      create: (_) => FilmographyProvider(id: id, page: page, data: firstPage),
      builder: (context, child) {
        final FilmographyProvider provider = Provider.of(context, listen: true);
        final height = MediaQuery.of(context).size.height;

        if (provider.exception != null) {
          return HandleError(provider.exception!, provider.onRefresh);
        }

        if (provider.isLoading && provider.data == null) {
          return UnconstrainedBox(
            child: SizedBox(height: height * 0.5, child: const Loading()),
          );
        }

        if (provider.page == 1) {
          context
              .read<ActorProfileProvider>()
              .addFirstMoviesPage(id, provider.data!);
        }

        final Widget data = Column(
            children: provider.data!
                .map((e) => CardMovie(
                    id: e.id,
                    heroTag: '${e.id.toString()}-$id}',
                    title: e.title,
                    poster: e.poster.mmed,
                    saveToCache: false))
                .toList());

        return InfiniteScroll(
          provider: provider,
          scrollController: scrollController,
          data: data,
        );
      },
    );
  }
}
