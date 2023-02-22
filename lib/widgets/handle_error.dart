import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vims/exceptions/maintenance_exception.dart';
import 'package:vims/pages/maintenance_screen.dart';
import 'package:vims/widgets/material_design_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late AppLocalizations i18n;

class HandleError extends StatelessWidget {
  final Exception error;
  final VoidCallback onRefresh;

  const HandleError(this.error, this.onRefresh, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context)!;

    if (error is TimeoutException) {
      return _ServerError(onRefresh);
    }

    if (error is MaintenanceException) {
      return MaintenanceScreen(error as MaintenanceException);
    }

    return _ConnectivityError(onRefresh: onRefresh);
  }
}

class _ServerError extends StatelessWidget {
  final VoidCallback onRefresh;
  const _ServerError(
    this.onRefresh, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(MaterialDesignIcons.emoticonConfusedOutline,
                size: 100, color: Colors.white),
            const SizedBox(height: 20),
            Text(i18n.timeout_error,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: onRefresh,
                child: Text(
                  i18n.retry,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                ))
          ],
        ),
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
