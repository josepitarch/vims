import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:scrapper_filmaffinity/widgets/movie_item.dart';
import 'dart:convert' as convert;

import '../models/movie.dart';

class TopMovies extends StatelessWidget {
  const TopMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: getTopMovies(),
            builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              List<Movie> movies = snapshot.data!;

              return ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (_, index) {
                    return MovieItem(
                      title: movies[index].title,
                      imageUrl: movies[index].poster,
                      director: movies[index].director,
                    );
                  });
            }),
      ),
    );
  }
}

Future<List<Movie>> getTopMovies() async {
  var url = Uri.http('35.246.48.193:8000', '/api/top/movies', {});
  var response = await http.get(url);
  var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
  List<Movie> result = [];
  for (var i = 0; i < jsonResponse.length; i++) {
    result.add(Movie.fromJson(convert.jsonEncode(jsonResponse[i])));
  }

  return result;
}
