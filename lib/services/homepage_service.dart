import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;

import 'package:scrapper_filmaffinity/models/section.dart';

class HomepageService {
  final String url = dotenv.env['URL']!;
  final String timeout = dotenv.env['TIMEOUT']!;
  final String versionApi = dotenv.env['VERSION_API']!;

  Future<List<Section>> getHomepageMovies() async {
    List<Section> homepageMovies = [];

    final request = Uri.http(url, '/api/$versionApi/homepage', {});

    final response =
        await http.get(request).timeout(Duration(seconds: int.parse(timeout)));

    if (response.statusCode == 200) {
      List aux = json.jsonDecode(response.body);
      aux.forEach((element) => homepageMovies.add(Section.fromMap(element)));
    }

    return homepageMovies.sublist(0, homepageMovies.length - 1);
  }
}
