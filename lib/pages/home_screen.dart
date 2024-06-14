import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vims/pages/search_screen.dart';
import 'package:vims/pages/sections_screen.dart';
import 'package:vims/pages/top_screen.dart';
import 'package:vims/pages/account_screen.dart';
import 'package:vims/providers/implementation/app_state_provider.dart';
import 'package:vims/providers/implementation/movie_provider.dart';
import 'package:vims/providers/implementation/section_provider.dart';
import 'package:vims/providers/implementation/sections_provider.dart';
import 'package:vims/utils/api.dart';
import 'package:vims/utils/custom_cache_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  final List<Widget> screens = [
    const SectionsScreen(),
    const TopMoviesScreen(),
    const SearchMovieScreen(),
    const UserProfileScreen()
  ];

  @override
  initState() {
    refreshIfIsNecessary();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refreshIfIsNecessary();
    }
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;

    final List destinations = [
      {'label': i18n.home, 'icon': Icons.home},
      {'label': i18n.top, 'icon': Icons.list_alt_sharp},
      {'label': i18n.search, 'icon': Icons.search_outlined},
      {'label': i18n.account, 'icon': Icons.account_circle_sharp}
    ];

    return Scaffold(
        body: screens.elementAt(_selectedIndex),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          indicatorColor: Colors.amber,
          selectedIndex: _selectedIndex,
          destinations: destinations
              .map((destination) => NavigationDestination(
                  icon: Icon(destination['icon'] as IconData),
                  label: destination['label'] as String))
              .toList(),
        ));
  }

  refreshIfIsNecessary() {
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

  checkIfIsMaintenance() {
    final AppStateProvider appStateProvider = context.read<AppStateProvider>();

    api('sections', 1)
        .then((value) => appStateProvider.setMaintenance(false))
        .catchError((e) => appStateProvider.setMaintenance(true));
  }
}
