import 'dart:async';

import 'package:vims/models/actor.dart';
import 'package:vims/utils/request.dart';

Future<Actor> getActorProfile(int id) async {
  final Map<String, dynamic> response = await request('actor/profile/$id', 2);

  return Actor.fromMap(response);
}
