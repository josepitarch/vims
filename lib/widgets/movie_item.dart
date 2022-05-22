import 'package:flutter/material.dart';

class MovieItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String director;

  const MovieItem(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.director})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: FadeInImage(
                height: 200,
                width: 130,
                fit: BoxFit.cover,
                image: NetworkImage(imageUrl),
                placeholder: const AssetImage('assets/loading.gif')),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 19),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  child: Text(
                    director,
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
    );
  }
}
