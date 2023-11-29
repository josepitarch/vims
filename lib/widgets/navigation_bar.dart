import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:vims/pages/bookmark_movies_screen.dart';
import 'package:vims/pages/search_movie_screen.dart';
import 'package:vims/pages/sections_screen.dart';
import 'package:vims/pages/top_movies_screen.dart';

class NavigatorBottomBarApp extends StatefulWidget {
  const NavigatorBottomBarApp({super.key});

  @override
  State<NavigatorBottomBarApp> createState() => _NavigatorBottomBarAppState();
}

class _NavigatorBottomBarAppState extends State<NavigatorBottomBarApp> {
  int _selectedIndex = 0;

  final List<Widget> screens = [
    const HomepageScreen(),
    const TopMoviesScreen(),
    const BookmarkMoviesScreen(),
    const SearchMovieScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;

    final List destinations = [
      {'label': i18n.home, 'icon': Icons.home},
      {'label': i18n.top, 'icon': Icons.list_alt_sharp},
      {'label': i18n.bookmarks, 'icon': Icons.bookmark},
      {'label': i18n.search, 'icon': Icons.search_outlined}
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
}
