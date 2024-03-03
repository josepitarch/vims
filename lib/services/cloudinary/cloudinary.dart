import 'dart:convert';

import 'package:http/http.dart';
import 'package:vims/models/enums/http_method.dart';
import 'package:vims/utils/api.dart';

Future<String> postPhotoProfile(String imagePath, String publicId) async {
  await api("users/$publicId/photo/$publicId", 1, method: HttpMethod.DELETE);

  final url =
      Uri.parse('https://api.cloudinary.com/v1_1/dukkvxlnu/image/upload');
  final request = MultipartRequest('POST', url)
    ..fields['upload_preset'] = 'vims-app'
    ..fields['public_id'] = publicId
    ..files.add(await MultipartFile.fromPath('file', imagePath));

  final response = await request.send();

  if (response.statusCode == 200) {
    final body = await response.stream.bytesToString();
    final url = json.decode(body)['secure_url'];

    return url;
  }

  throw Exception('Failed to upload photo');
}
