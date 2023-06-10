import 'package:collection/collection.dart';
import 'package:vims/models/actor.dart';
import 'package:vims/models/actor_movie.dart';
import 'package:vims/providers/interface/base_providert.dart';
import 'package:vims/services/api/actor_profile_service.dart';

class ActorProfileProvider extends BaseProvider<Map<Actor, List<ActorMovie>>> {
  late int id;
  Actor? currentActor;
  ActorProfileProvider() : super(data: {});

  @override
  fetchData() {
    isLoading = true;
    getActorProfile(id)
        .then((actor) {
          currentActor = actor;
          data!.addAll({actor: []});
          exception = null;
        })
        .catchError((e) => exception = e)
        .whenComplete(() {
          isLoading = false;
          notifyListeners();
        });
  }

  @override
  onRefresh() {
    isLoading = true;
    exception = null;
    notifyListeners();
    fetchData();
  }

  getProfile(int id) {
    this.id = id;
    final Actor? actor =
        data!.keys.firstWhereOrNull((element) => element.id == id);
    actor != null ? currentActor = actor : fetchData();
  }
}
