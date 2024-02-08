import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:vims/models/enums/http_method.dart';
import 'package:vims/models/exceptions/error_exception.dart';
import 'package:vims/models/exceptions/maintenance_exception.dart';
import 'package:vims/models/exceptions/unsupported_exception.dart';

import 'dart:io' as io show Platform;

final String BASE_URL = dotenv.env['URL']!;
final String TIMEOUT = dotenv.env['TIMEOUT']!;
final String API_TOKEN = dotenv.env['API_TOKEN']!;

Future request(String path, int versionApi,
    {HttpMethod? method = HttpMethod.GET,
    Map<String, dynamic>? queryParams,
    Object? body}) async {
  final String userAgent = io.Platform.isAndroid ? 'android' : 'ios';

  final Uri uri = BASE_URL.contains('vims')
      ? Uri.https(BASE_URL, '/v$versionApi/$path', queryParams)
      : Uri.http(BASE_URL, '/v$versionApi/$path', queryParams);

  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $API_TOKEN',
    'User-Agent': userAgent,
  };

  Future<Response> request = method == HttpMethod.GET
      ? get(uri, headers: headers)
      : post(uri, headers: headers, body: body);

  Response response =
      await request.timeout(Duration(seconds: int.parse(TIMEOUT))).catchError(
            (Object e) => throw ErrorServerException('Connection timeout'),
          );

  if (response.statusCode == 200) return jsonDecode(response.body);

  if (response.statusCode == 405) {
    throw UnsupportedServerException('Method not allowed for this api version');
  }

  if (response.statusCode == 503) {
    final body = jsonDecode(response.body);
    final String message = body['message'];

    throw MaintenanceException(message);
  }

  throw ErrorServerException(response.body);
}
