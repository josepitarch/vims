import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:vims/models/exceptions/error_exception.dart';
import 'package:vims/models/exceptions/maintenance_exception.dart';
import 'package:vims/models/exceptions/unsupported_exception.dart';

final String BASE_URL = dotenv.env['URL']!;
final String TIMEOUT = dotenv.env['TIMEOUT']!;

Future request(String path, String versionApi,
    [Map<String, dynamic>? parameters]) async {
  final Uri request = Uri.http(BASE_URL, '/$versionApi/$path', parameters);

  final Response response =
      await get(request).timeout(Duration(seconds: int.parse(TIMEOUT)));

  if (response.statusCode == 200) return jsonDecode(response.body);

  if (response.statusCode == 405) {
    throw UnsupportedServerException(
        'Method not allowed for this version of API');
  }

  if (response.statusCode == 503) {
    final body = jsonDecode(response.body);
    final String image = body['image'];
    final String message = body['message'];

    throw MaintenanceException(image, message);
  }

  throw ErrorServerException(response.body);
}
