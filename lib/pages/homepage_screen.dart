import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:vims/providers/details_movie_provider.dart';
import 'package:vims/providers/homepage_provider.dart';
import 'package:vims/shimmer/sections_shimmer.dart';
import 'package:vims/utils/custom_cache_manager.dart';
import 'package:vims/widgets/pull_refresh.dart';
import 'package:vims/widgets/section_widget.dart';
import 'package:vims/widgets/handle_error.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({Key? key}) : super(key: key);

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen>
    with WidgetsBindingObserver {
  @override
  initState() {
    refreshIfIsNecessary(context);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refreshIfIsNecessary(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomepageProvider>(builder: (_, provider, __) {
      if (provider.error != null)
        return HandleError(provider.error!, provider.onRefresh);
      if (provider.isLoading) return const SectionsShimmer();

      return PullRefresh(
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

void refreshIfIsNecessary(BuildContext context) {
  final String timeToRefresh = dotenv.env['TIME_REFRESH_HOMEPAGE']!;
  final homepageProvider =
      Provider.of<HomepageProvider>(context, listen: false);
  final detailsMovieProvider =
      Provider.of<DetailsMovieProvider>(context, listen: false);
  final Duration difference =
      DateTime.now().difference(homepageProvider.lastUpdate);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (difference.inSeconds >= int.parse(timeToRefresh)) {
      CustomCacheManager.cacheTinyImages.emptyCache();
      homepageProvider.onRefresh();
      detailsMovieProvider.clear();
    }
  });
}
