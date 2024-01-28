import 'dart:async';

import 'package:logger/logger.dart';
import 'package:vims/models/actor.dart';
import 'package:vims/providers/interface/infinite_scroll_provider.dart';
import 'package:vims/repositories/implementation/search_history_repository.dart';
import 'package:vims/repositories/interface/search_history_repository.dart';
import 'package:vims/services/api/search_person_service.dart';
import 'package:vims/services/api/search_movie_service.dart';
import 'package:vims/utils/debounce.dart';

class SearchActorProvider extends InfiniteScrollProvider<Actor> {
  final SearchHistoryRepository repository = SearchHistoryRepositoryImpl();
  String search = '';
  final String order = 'relevance';

  final Logger logger = Logger();

  final _debouncer = Debouncer(milliseconds: 400);

  SearchActorProvider() : super(page: 1, limit: 50) {
    isLoading = false;
  }

  @override
  fetchData() {
    isLoading = true;
    notifyListeners();

    getActorSuggestions(search.toLowerCase(), page, order).then((value) {
      total = value.total;
      hasNextPage = value.results.length < total!;
      data == null
          ? data = List.of(value.results)
          : data!.addAll(value.results);
      exception = null;
    }).catchError((e) {
      exception = e;
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  setTabIndex(int index) {
    search = '';
    notifyListeners();
  }

  getSuggestionsAutocomplete(String search) {
    isLoading = true;
    this.search = search;

    getAutocomplete(search.toLowerCase()).then((value) {
      data = value.actors;
      exception = null;
    }).catchError((e) {
      exception = e;
    }).whenComplete(() {
      isLoading = false;
      hasNextPage = false;
      total = null;
      notifyListeners();
    });
  }

  Future<List<String>> getHistorySearchs() {
    return repository.getAllSearchActorsHistory().then((value) => value);
  }

  insertHistorySearch(String search) {
    repository.addSearchActorHistory(search);
  }

  deleteAllSearchs() {
    repository.removeAllSearchActorsHistory();
    notifyListeners();
  }

  onTapHistorySearch(String search) {
    this.search = search;
    onRefresh();
  }

  void onChanged(String search) {
    search = search.trim();
    _debouncer.run(() {
      getSuggestionsAutocomplete(search);
    });
  }

  onSubmitted(String search) {
    if (search.isEmpty) return;
    _debouncer.cancel();
    this.search = search;
    onRefresh();
    insertHistorySearch(search);
  }
}
