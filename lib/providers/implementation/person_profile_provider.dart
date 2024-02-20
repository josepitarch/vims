import 'package:collection/collection.dart';
import 'package:vims/models/actor.dart';
import 'package:vims/models/actor_movie.dart';
import 'package:vims/providers/interface/base_providert.dart';
import 'package:vims/services/api/person_service.dart';

final class ActorProfileProvider
    extends BaseProvider<Map<Actor, List<ActorMovie>?>> {
  late int id;
  Actor? currentActor;
  ActorProfileProvider() : super(data: {});

  @override
  fetchData() {
    isLoading = true;
    getPersonProfile(id).then((actor) {
      currentActor = actor;
      data!.addAll({actor: null});
      exception = null;
    }).catchError((e) {
      exception = e;
    }).whenComplete(() {
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

  fetchProfile(int id) {
    this.id = id;
    final Actor? actor =
        data!.keys.firstWhereOrNull((element) => element.id == id);
    actor != null ? currentActor = actor : fetchData();
  }

  Map<Actor, List<ActorMovie>?> getActor(final int id) {
    final Actor? actor =
        data!.keys.firstWhereOrNull((element) => element.id == id);
    if (actor != null) {
      return {actor: data![actor]};
    }
    return {};
  }

  addFirstMoviesPage(final int id, final List<ActorMovie> movies) {
    final Actor? actor =
        data!.keys.firstWhereOrNull((element) => element.id == id);
    if (actor != null) {
      data![actor] = movies;
    }
  }
}
