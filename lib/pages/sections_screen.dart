import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:vims/providers/implementation/movie_provider.dart';
import 'package:vims/providers/implementation/section_provider.dart';
import 'package:vims/providers/implementation/sections_provider.dart';
import 'package:vims/utils/custom_cache_manager.dart';
import 'package:vims/widgets/handle_error.dart';
import 'package:vims/widgets/pull_refresh.dart';
import 'package:vims/widgets/section_widget.dart';
import 'package:vims/widgets/shimmer/sections_screen_shimmer.dart';

class SectionsScreen extends StatefulWidget {
  const SectionsScreen({super.key});

  @override
  State<SectionsScreen> createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen>
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
    final SectionsProvider provider = Provider.of(context, listen: true);

    if (provider.exception != null)
      return HandleError(provider.exception!, provider.onRefresh);

    if (provider.isLoading) return const SectionsShimmer();

    final List<SectionWidget> sections = provider.data!
        .map((section) => SectionWidget(section: section))
        .toList();

    final Widget body = Theme.of(context).platform == TargetPlatform.android
        ? ListView(
            children: [
              ...sections,
              const SizedBox(height: 30),
            ],
          )
        : Column(
            children: [
              ...sections,
              const SizedBox(height: 30),
            ],
          );

    return PullRefresh(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: body,
        ),
        onRefresh: () {
          context.read<SectionProvider>().onRefresh();
          return provider.onRefresh();
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
  final SectionsProvider homepageProvider = context.read<SectionsProvider>();

  final Duration difference =
      DateTime.now().difference(homepageProvider.lastUpdate);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (difference.inSeconds >= int.parse(timeToRefresh)) {
      CustomCacheManager.cacheTinyImages.emptyCache();
      homepageProvider.onRefresh();
      context.read<SectionProvider>().onRefresh();
      context.read<MovieProvider>().clear();
    }
  });
}
