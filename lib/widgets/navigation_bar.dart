import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vims/pages/bookmark_movies_screen.dart';
import 'package:vims/pages/search_screen.dart';
import 'package:vims/pages/sections_screen.dart';
import 'package:vims/pages/top_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> screens = [
    const SectionsScreen(),
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
