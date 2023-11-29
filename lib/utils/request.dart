import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:vims/models/exceptions/error_exception.dart';
import 'package:vims/models/exceptions/maintenance_exception.dart';
import 'package:vims/models/exceptions/unsupported_exception.dart';

final String BASE_URL = dotenv.env['URL']!;
final String TIMEOUT = dotenv.env['TIMEOUT']!;

Future request(String path, int versionApi,
    [Map<String, dynamic>? parameters]) async {
  const String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.zljhJvx-95zOkdnAb4DA0CRXx7jYw_6jYd4KbMpIOrA';

  final Uri request = BASE_URL.contains('vims')
      ? Uri.https(BASE_URL, '/v$versionApi/$path', parameters)
      : Uri.http(BASE_URL, '/v$versionApi/$path', parameters);

  final Response response = await get(request, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
    'User-Agent': 'android',
  }).timeout(Duration(seconds: int.parse(TIMEOUT))).catchError(
        (Object e) => throw ErrorServerException('Connection timeout'),
      );

  if (response.statusCode == 200) return jsonDecode(response.body);

  if (response.statusCode == 405) {
    throw UnsupportedServerException('Method not allowed for this api version');
  }

  if (response.statusCode == 503) {
    final body = jsonDecode(response.body);
    final String image = body['image'];
    final String message = body['message'];

    throw MaintenanceException(image, message);
  }

  throw ErrorServerException(response.body);
}
