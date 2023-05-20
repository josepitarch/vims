import 'dart:async';
import 'dart:convert' as json;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:vims/exceptions/maintenance_exception.dart';
import 'package:vims/models/section.dart';

class SeeMoreService {
  final String url = dotenv.env['URL']!;
  final String timeout = dotenv.env['TIMEOUT']!;
  final String versionApi = dotenv.env['VERSION_API']!;

  final logger = Logger();

  Future<List<MovieSection>> getSeeMore(String section) async {
    List<MovieSection> seeMoreMovies = [];

    final request =
        Uri.http(url, '/api/v2/release/section', {'section': section});

    final response =
        await http.get(request).timeout(Duration(seconds: int.parse(timeout)));

    if (response.statusCode == 500 || response.statusCode == 502) {
      throw TimeoutException(response.body);
    }

    if (response.statusCode == 503) {
      final body = json.jsonDecode(response.body);
      throw MaintenanceException(body['image'], body['message']);
    }

    if (response.statusCode == 200) {
      List aux = json.jsonDecode(response.body);
      aux.forEach(
          (element) => seeMoreMovies.add(MovieSection.fromMap(element)));
      return seeMoreMovies;
    }

    return seeMoreMovies;
  }
}
