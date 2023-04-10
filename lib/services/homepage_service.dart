import 'dart:async';
import 'dart:convert' as json;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:vims/exceptions/maintenance_exception.dart';
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

    if (response.statusCode == 500 || response.statusCode == 502) {
      throw TimeoutException(response.body);
    }

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
}
