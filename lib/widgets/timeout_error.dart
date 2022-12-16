import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/providers/details_movie_provider.dart';
import 'package:scrapper_filmaffinity/providers/homepage_provider.dart';
import 'package:scrapper_filmaffinity/providers/search_movie_provider.dart';
import 'package:scrapper_filmaffinity/providers/top_movies_provider.dart';
import 'package:scrapper_filmaffinity/widgets/material_design_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late AppLocalizations i18n;
late ChangeNotifier changeNotifier;

class TimeoutError extends StatelessWidget {
  final Exception error;
  final ChangeNotifier provider;
  const TimeoutError(this.error, this.provider, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context)!;
    changeNotifier = provider;

    return error is TimeoutException
        ? const _ServerError()
        : const _ConnectivityError();
  }
}

class _ServerError extends StatelessWidget {
  const _ServerError({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomepageProvider homepageProvider =
        Provider.of<HomepageProvider>(context, listen: false);
    final TopMoviesProvider topMoviesProvider =
        Provider.of<TopMoviesProvider>(context, listen: false);
    final DetailsMovieProvider detailsMovieProvider =
        Provider.of<DetailsMovieProvider>(context, listen: false);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(MaterialDesignIcons.emoticonConfusedOutline,
              size: 100, color: Colors.white),
          const SizedBox(height: 20),
          Text(i18n.timeout_error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6),
          TextButton(
              onPressed: () {
                homepageProvider.onRefresh();
                topMoviesProvider.onRefresh();
                detailsMovieProvider.onRefresh();
              },
              child: Text(i18n.retry))
        ],
      ),
    );
  }
}

class _ConnectivityError extends StatefulWidget {
  const _ConnectivityError({Key? key}) : super(key: key);

  @override
  State<_ConnectivityError> createState() => _ConnectivityErrorState();
}

class _ConnectivityErrorState extends State<_ConnectivityError> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (_) {
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      if (result != ConnectionState.none) {
        if (changeNotifier is HomepageProvider) {
          (changeNotifier as HomepageProvider).onRefresh();
        } else if (changeNotifier is TopMoviesProvider) {
          (changeNotifier as TopMoviesProvider).onRefresh();
        } else if (changeNotifier is DetailsMovieProvider) {
          (changeNotifier as DetailsMovieProvider).onRefresh();
        } else if (changeNotifier is SearchMovieProvider) {
          (changeNotifier as SearchMovieProvider).onRefresh();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 80),
              const SizedBox(height: 20),
              Text(i18n.no_internet,
                  style: Theme.of(context).textTheme.headline6),
            ]),
      ),
    );
  }
}
