import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';

class CardMovie extends StatelessWidget {
  final Movie movie;
  final bool? hasAllAttributes;

  const CardMovie({Key? key, required this.movie, this.hasAllAttributes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = 150.0;
    return InkWell(
      splashColor: Colors.orange.shade400,
      onTap: () {
        Map<String, dynamic> arguments = {
          'id': movie.id,
          'movie': movie,
          'hasAllAttributes': hasAllAttributes ?? false,
        };
        Navigator.pushNamed(context, 'details', arguments: arguments);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        margin: const EdgeInsets.only(bottom: 20.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _Poster(height: height, movie: movie),
          Expanded(
            child: Container(
                height: height,
                margin: const EdgeInsets.only(left: 10, top: 15),
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      _Title(movie.title),
                      const SizedBox(height: 10.0),
                      _Director(movie.director),
                    ]),
                    _Average(movie.average, height: height)
                  ],
                )),
          ),
          SizedBox(
              height: height,
              child: const Icon(Icons.arrow_forward_ios_outlined))
        ]),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({
    Key? key,
    required this.height,
    required this.movie,
  }) : super(key: key);

  final double height;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    const double width = 120.0;
    return Hero(
      tag: movie.id,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: FadeInImage(
            height: height + 20,
            width: width,
            fit: BoxFit.cover,
            image: NetworkImage(movie.poster),
            placeholder: const AssetImage('assets/loading.gif'),
            imageErrorBuilder: (_, __, ___) => Image.asset(
                'assets/no-image.jpg',
                height: height + 30,
                fit: BoxFit.cover,
                width: width)),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  const _Title(
    this.title, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline3,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}

class _Director extends StatelessWidget {
  final String? director;
  const _Director(
    this.director, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Text(
        director ?? '',
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontStyle: FontStyle.italic,
              //color: Theme.of(context).colorScheme.secondary
            ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}

class _Average extends StatelessWidget {
  final String average;
  final double height;
  const _Average(
    this.average, {
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String averageText = average.isNotEmpty ? average : '---';
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.yellow),
        const SizedBox(width: 5),
        Text(averageText, style: Theme.of(context).textTheme.headline4),
      ],
    );
  }
}
