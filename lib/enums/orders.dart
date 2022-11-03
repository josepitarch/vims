import 'package:scrapper_filmaffinity/models/movie.dart';

enum OrderBy {
  average(
      {'en': 'Average', 'es': 'Puntación', 'func': OrderByFunctions.average}),
  year({'en': 'Year', 'es': 'Año', 'func': OrderByFunctions.year}),
  shuffle(
      {'en': 'Shuffle', 'es': 'Aleatorio', 'func': OrderByFunctions.shuffle});

  const OrderBy(this._value);
  final Map<String, dynamic> _value;
  Map<String, dynamic> get value => _value;
}

class OrderByFunctions {
  static List<Movie> shuffle(List<Movie> movies) {
    movies.shuffle();
    return movies;
  }

  static List<Movie> average(List<Movie> movies) {
    movies.sort((a, b) => double.parse(b.average.replaceFirst(',', '.'))
        .compareTo(double.parse(a.average.replaceFirst(',', '.'))));
    return movies;
  }

  static List<Movie> year(List<Movie> movies) {
    movies.sort((a, b) => int.parse(a.year).compareTo(int.parse(b.year)));
    return movies;
  }
}
