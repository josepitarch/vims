import 'dart:convert';

import 'package:http/http.dart';

Future<String> postPhotoProfile(String imagePath) async {
  final url =
      Uri.parse('https://api.cloudinary.com/v1_1/dukkvxlnu/image/upload');
  final request = MultipartRequest('POST', url)
    ..fields['upload_preset'] = 'vims-app'
    ..files.add(await MultipartFile.fromPath('file', imagePath));
  final response = await request.send();

  if (response.statusCode == 200) {
    final body = await response.stream.bytesToString();
    final url = json.decode(body)['secure_url'];

    return url;
  }

  throw Exception('Failed to upload photo');
}
