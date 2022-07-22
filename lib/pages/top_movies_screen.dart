import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/providers/top_movies_provider.dart';
import 'package:scrapper_filmaffinity/widgets/title_page.dart';

import '../widgets/movie_item.dart';

class TopMoviesScreen extends StatelessWidget {
  const TopMoviesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TopMoviesProvider>(builder: (_, provider, __) {
      if (provider.existsError) {
        return const Center(
          child: Text('Error'),
        );
      }

      return provider.filteredMovies.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _TopMovies(
              provider: provider,
            );
    });
  }
}

class _TopMovies extends StatelessWidget {
  final TopMoviesProvider provider;
  const _TopMovies({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitlePage('Si no sabes que ver'),
          _PlatformsFilter(provider: provider),
          Expanded(
            child: ListView.builder(
                itemCount: provider.filteredMovies.length,
                itemBuilder: (_, index) {
                  return MovieItem(
                    movie: provider.filteredMovies[index],
                    hasAllAttributes: false,
                  );
                }),
          ),
        ],
      )),
    );
  }
}

class _PlatformsFilter extends StatefulWidget {
  final TopMoviesProvider provider;
  const _PlatformsFilter({Key? key, required this.provider}) : super(key: key);

  @override
  State<_PlatformsFilter> createState() => _PlatformsFilterState();
}

class _PlatformsFilterState extends State<_PlatformsFilter> {
  @override
  Widget build(BuildContext context) {
    Map<String, bool> platforms = Map.from(widget.provider.platforms);
    List<String> names = platforms.keys.toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 70,
            child: ListView.builder(
                itemCount: widget.provider.platforms.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        widget.provider.setPlatform(names[index]);
                        setState(() {
                          bool value = platforms[names[index]]!;
                          platforms[names[index]] = !value;
                        });
                      },
                      child: Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/justwatch/${names[index]}.jpg',
                            fit: BoxFit.cover,
                            height: 50,
                            errorBuilder: (_, __, ___) => Container(),
                          ),
                        ),
                        if (platforms[names[index]]!)
                          const Positioned(
                              right: 0,
                              bottom: 15,
                              width: 20,
                              height: 20,
                              child: CircleAvatar(
                                  child: Icon(
                                      size: 10,
                                      Icons.check,
                                      color: Colors.white)))
                      ]),
                    ),
                  );
                }),
          ),
          MaterialButton(
              onPressed: () => widget.provider.applyFilters(),
              child: const Text('Aplicar filtros')),
        ],
      ),
    );
  }
}
