import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vims/models/section.dart';
import 'package:vims/utils/request.dart';

class HomepageService {
  final String url = dotenv.env['URL']!;
  final String timeout = dotenv.env['TIMEOUT']!;
  final String versionApi = dotenv.env['VERSION_API']!;

  Future<List<Section>> getSections() async {
    final List response = await request('sections', 'v2');

    return response.map((section) => Section.fromMap(section)).toList();
  }
}
