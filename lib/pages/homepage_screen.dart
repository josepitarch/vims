import 'dart:io' as io show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/providers/homepage_provider.dart';
import 'package:scrapper_filmaffinity/shimmer/sections_shimmer.dart';
import 'package:scrapper_filmaffinity/utils/custom_cache_manager.dart';
import 'package:scrapper_filmaffinity/widgets/pull_refresh.dart';
import 'package:scrapper_filmaffinity/widgets/section.dart';
import 'package:scrapper_filmaffinity/widgets/timeout_error.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({Key? key}) : super(key: key);

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen>
    with WidgetsBindingObserver {
  final String timeToRefresh = dotenv.env['TIME_REFRESH_HOMEPAGE']!;

  @override
  initState() {
    refreshIfIsNecessary(context, int.parse(timeToRefresh));
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refreshIfIsNecessary(context, int.parse(timeToRefresh));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomepageProvider>(builder: (_, provider, __) {
      if (provider.error != null) {
        return TimeoutError(provider.error!, provider);
      }

      if (provider.isLoading) return const SectionsShimmer();

      return PullRefresh(
          isAndroid: io.Platform.isAndroid,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(children: [
              ...provider.sections
                  .map((section) => SectionWidget(section: section))
                  .toList(),
              const SizedBox(height: 30),
            ]),
          )),
          onRefresh: () => provider.onRefresh());
    });
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

void refreshIfIsNecessary(BuildContext context, int timeToRefresh) {
  final provider = Provider.of<HomepageProvider>(context, listen: false);
  final Duration difference = DateTime.now().difference(provider.lastUpdate);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (difference.inHours >= timeToRefresh) {
      CustomCacheManager.cacheTinyImages.emptyCache();
      provider.onRefresh();
    }
  });
}
