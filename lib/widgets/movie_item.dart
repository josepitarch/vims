import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';

class MovieItem extends StatelessWidget {
  final Movie movie;
  final bool? isFavorite;

  const MovieItem({Key? key, required this.movie, this.isFavorite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          Map<String, dynamic> arguments = {
            'movie': movie,
            'isFavorite': isFavorite,
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
                    height: 200,
                    width: 130,
                    fit: BoxFit.cover,
                    image: NetworkImage(movie.poster),
                    placeholder: const AssetImage('assets/loading.gif')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      movie.title,
                      style: const TextStyle(fontSize: 19),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 200,
                    child: Text(
                      movie.director ?? '',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 200, child: Icon(Icons.arrow_forward_ios_outlined))
          ]),
        ),
      ),
    );
  }
}
