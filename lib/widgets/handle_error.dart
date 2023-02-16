import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vims/exceptions/maintenance_exception.dart';
import 'package:vims/pages/maintenance_screen.dart';
import 'package:vims/providers/details_movie_provider.dart';
import 'package:vims/providers/homepage_provider.dart';
import 'package:vims/providers/top_movies_provider.dart';
import 'package:vims/widgets/material_design_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late AppLocalizations i18n;

class HandleError extends StatelessWidget {
  final Exception error;
  final VoidCallback onRefresh;
  final String page;
  const HandleError(this.error, this.onRefresh, this.page, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context)!;

    if (error is TimeoutException) {
      return _ServerError(page);
    }

    if (error is MaintenanceException) {
      return MaintenanceScreen(error as MaintenanceException);
    }

    return _ConnectivityError(onRefresh: onRefresh);
  }
}

class _ServerError extends StatelessWidget {
  final String page;
  const _ServerError(
    this.page, {
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
          ElevatedButton(
              onPressed: () {
                {
                  switch (page) {
                    case 'homepage':
                      homepageProvider.onRefresh();
                      break;
                    case 'top':
                      topMoviesProvider.onRefresh();
                      break;
                    case 'details':
                      detailsMovieProvider.onRefresh();
                      break;
                    default:
                      homepageProvider.getSeeMore(page);
                  }
                }
              },
              child: Text(
                i18n.retry,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
              ))
        ],
      ),
    );
  }
}

class _ConnectivityError extends StatefulWidget {
  final VoidCallback onRefresh;
  const _ConnectivityError({required this.onRefresh, Key? key})
      : super(key: key);

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
        widget.onRefresh();
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
