import 'package:vims/models/enums/http_method.dart';
import 'package:vims/utils/api.dart';

Future<bool> createFcmToken(String userId, int page, int size) async {
  await api('users/$userId/fcm/token', 1, method: HttpMethod.POST);

  return true;
}
