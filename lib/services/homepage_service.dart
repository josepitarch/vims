import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:vims/exceptions/maintenance_exception.dart';
import 'dart:convert' as json;

import 'package:vims/models/section.dart';

class HomepageService {
  final String url = dotenv.env['URL']!;
  final String timeout = dotenv.env['TIMEOUT']!;
  final String versionApi = dotenv.env['VERSION_API']!;

  Future<List<Section>> getHomepageMovies() async {
    List<Section> homepageMovies = [];

    final request = Uri.http(url, '/api/$versionApi/homepage', {});

    final response =
        await http.get(request).timeout(Duration(seconds: int.parse(timeout)));

    if (response.statusCode == 500) throw TimeoutException(response.body);

    if (response.statusCode == 503) {
      final body = json.jsonDecode(response.body);
      throw MaintenanceException(body['image'], body['message']);
    }

    if (response.statusCode == 200) {
      List aux = json.jsonDecode(response.body);
      aux.forEach((element) => homepageMovies.add(Section.fromMap(element)));
      return homepageMovies;
    }

    return homepageMovies;
  }

  Future<List<MovieSection>> getSeeMore(String section, bool isRelease) async {
    List<MovieSection> seeMoreMovies = [];

    final request = isRelease
        ? Uri.http(url, '/api/$versionApi/release/section/$section')
        : Uri.http(url, '/api/$versionApi/coming/section');

    final response =
        await http.get(request).timeout(Duration(seconds: int.parse(timeout)));

    if (response.statusCode == 500) throw TimeoutException(response.body);

    if (response.statusCode == 200) {
      List aux = json.jsonDecode(response.body);
      aux.forEach(
          (element) => seeMoreMovies.add(MovieSection.fromMap(element)));
      return seeMoreMovies;
    }

    return seeMoreMovies;
  }
}
