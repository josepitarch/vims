import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vims/models/actor.dart';
import 'package:vims/pages/loading_screen.dart';
import 'package:vims/providers/implementation/actor_filmography_provider.dart';
import 'package:vims/providers/implementation/actor_profile_provider.dart';
import 'package:vims/widgets/avatar.dart';
import 'package:vims/widgets/card_movie.dart';
import 'package:vims/widgets/country.dart';
import 'package:vims/widgets/infinite_scroll.dart';

class ActorScreen extends StatelessWidget {
  const ActorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    final int id = ModalRoute.of(context)!.settings.arguments as int;
    final ActorProfileProvider provider =
        Provider.of<ActorProfileProvider>(context, listen: true)
          ..getProfile(id);

    if (provider.isLoading) {
      return const LoadingScreen();
    }

    return Scaffold(
        body: CustomScrollView(controller: controller, slivers: [
      const _Profile(),
      SliverList(
          delegate: SliverChildListDelegate([
        _Filmography(
          scrollController: controller,
        )
      ])),
    ]));
  }
}

class _Profile extends StatelessWidget {
  const _Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final Actor actor =
        Provider.of<ActorProfileProvider>(context, listen: false).currentActor!;

    final String age = actor.age ?? '';
    final String totalMovies = actor.totalMovies?.toString() ?? '';
    final String country = actor.nacionality ?? '';
    final String flag = actor.flag ?? '';

    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.23,
      floating: false,
      pinned: true,
      backgroundColor: Colors.grey[900],
      elevation: 0.0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          actor.name,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        background: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 60.0, top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvatarView(imagePath: actor.image?.mmed ?? '', radius: 50),
                const SizedBox(width: 10.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(age, style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 10.0),
                    Text('$totalMovies películas',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 10.0),
                    Country(country: country),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Filmography extends StatefulWidget {
  final ScrollController scrollController;
  const _Filmography({required this.scrollController, super.key});

  @override
  State<_Filmography> createState() => _FilmographyState();
}

class _FilmographyState extends State<_Filmography> {
  @override
  Widget build(BuildContext context) {
    final int id = ModalRoute.of(context)!.settings.arguments as int;
    return ChangeNotifierProvider(
      create: (_) => FilmographyProvider(id: id, page: 1),
      builder: (context, child) {
        final FilmographyProvider provider =
            Provider.of<FilmographyProvider>(context, listen: true);
        addListener(provider);
        final Widget data = Column(
            children: provider.data!
                .map((e) => CardMovie(
                    id: e.id,
                    heroTag: '${e.id.toString()}-$id}',
                    title: e.title,
                    poster: e.poster.mmed,
                    saveToCache: false))
                .toList());
        return InfiniteScroll(data: data, isLoading: provider.isLoading);
      },
    );
  }

  addListener(FilmographyProvider provider) {
    final ScrollController scrollController = widget.scrollController;
    scrollController.addListener(() {
      final double currentPosition = scrollController.position.pixels;
      final double maxScroll = scrollController.position.maxScrollExtent;
      provider.scrollPosition = currentPosition;

      if (currentPosition + 300 >= maxScroll &&
          !provider.isLoading &&
          provider.hasNextPage) {
        provider.fetchNextPage();
      }
    });
  }

  @override
  dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }
}
