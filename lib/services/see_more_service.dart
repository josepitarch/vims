import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:vims/enums/title_sections.dart';
import 'dart:convert' as json;

import 'package:vims/models/section.dart';

class SeeMoreService {
  final String url = dotenv.env['URL']!;
  final String timeout = dotenv.env['TIMEOUT']!;
  final String versionApi = dotenv.env['VERSION_API']!;

  final logger = Logger();

  Future<List<MovieSection>> getSeeMore(String section) async {
    List<MovieSection> seeMoreMovies = [];

    final bool isRelease =
        !TitleSectionEnum.coming_theaters.value.contains(section);

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