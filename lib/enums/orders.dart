import 'package:vims/models/movie.dart';

enum OrderBy {
  average('average', OrderByFunctions.average),
  year('year', OrderByFunctions.year),
  shuffle('shuffle', OrderByFunctions.shuffle);

  const OrderBy(this._value, this._func);
  final String _value;
  final Function _func;
  String get value => _value;
  Function get func => _func;
}

class OrderByFunctions {
  static List<Movie> shuffle(List<Movie> movies) {
    movies.shuffle();
    return movies;
  }

  static List<Movie> average(List<Movie> movies) {
    movies.sort((a, b) => b.rating!.compareTo(a.rating!));
    return movies;
  }

  static List<Movie> year(List<Movie> movies) {
    movies.sort((a, b) => int.parse(a.year).compareTo(int.parse(b.year)));
    return movies;
  }
}
