import 'dart:async';

import 'package:vims/models/actor.dart';
import 'package:vims/utils/request.dart';

Future<Actor> getActorProfile(int id) async {
  final Map<String, dynamic> response = await request('person/profile/$id', 1);

  return Actor.fromMap(response);
}
