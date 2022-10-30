import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';

class CardMovie extends StatelessWidget {
  final Movie movie;
  final bool? hasAllAttributes;

  const CardMovie({Key? key, required this.movie, this.hasAllAttributes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: Limit width of title and director
    double height = 170.0;
    return GestureDetector(
      onTap: () {
        Map<String, dynamic> arguments = {
          'id': movie.id,
          'movie': movie,
          'hasAllAttributes': hasAllAttributes ?? false,
        };
        Navigator.pushNamed(context, 'details', arguments: arguments);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Hero(
            tag: movie.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: FadeInImage(
                  height: height,
                  width: 120,
                  fit: BoxFit.cover,
                  image: NetworkImage(movie.poster),
                  placeholder: const AssetImage('assets/loading.gif'),
                  imageErrorBuilder: (_, __, ___) => Image.asset(
                      'assets/no-image.jpg',
                      height: height,
                      fit: BoxFit.cover,
                      width: 120)),
            ),
          ),
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(left: 10, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.headline3,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      movie.director ?? '',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontStyle: FontStyle.italic,
                            //color: Theme.of(context).colorScheme.secondary
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    movie.average.isNotEmpty
                        ? SizedBox(
                            height: height - 30,
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.yellow),
                                const SizedBox(width: 5),
                                Text(movie.average,
                                    style:
                                        Theme.of(context).textTheme.headline4),
                              ],
                            ))
                        : Container()
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
