import 'package:collection/collection.dart';
import 'package:vims/models/person.dart';
import 'package:vims/models/actor_movie.dart';
import 'package:vims/providers/interface/base_providert.dart';
import 'package:vims/services/api/person_service.dart';

final class ProfileProvider
    extends BaseProvider<Map<Person, List<ActorMovie>?>> {
  late int id;
  Person? currentActor;
  ProfileProvider() : super(data: {});

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
    final Person? actor =
        data!.keys.firstWhereOrNull((element) => element.id == id);
    actor != null ? currentActor = actor : fetchData();
  }

  Map<Person, List<ActorMovie>?> getActor(final int id) {
    final Person? actor =
        data!.keys.firstWhereOrNull((element) => element.id == id);
    if (actor != null) {
      return {actor: data![actor]};
    }
    return {};
  }

  addFirstMoviesPage(final int id, final List<ActorMovie> movies) {
    final Person? actor =
        data!.keys.firstWhereOrNull((element) => element.id == id);
    if (actor != null) {
      data![actor] = movies;
    }
  }
}
