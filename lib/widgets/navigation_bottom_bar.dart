import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:scrapper_filmaffinity/pages/bookmark_movies_screen.dart';
import 'package:scrapper_filmaffinity/pages/search_movie_screen.dart';
import 'package:scrapper_filmaffinity/pages/top_movies_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scrapper_filmaffinity/pages/homepage_screen.dart';

class NavigatorBottomBarApp extends StatefulWidget {
  const NavigatorBottomBarApp({Key? key}) : super(key: key);

  @override
  State<NavigatorBottomBarApp> createState() => _NavigatorBottomBarAppState();
}

class _NavigatorBottomBarAppState extends State<NavigatorBottomBarApp> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    const HomepageScreen(),
    const TopMoviesScreen(),
    const BookmarkMoviesScreen(),
    const SearchMovieScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        //backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 16,
        unselectedFontSize: 14,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: (index) {
          Vibrate.canVibrate.then(
              (value) => value ? Vibrate.feedback(FeedbackType.medium) : null);
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: i18n.home,
            icon: const Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: i18n.top,
            icon: const Icon(Icons.list_alt_sharp),
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.bookmark), label: i18n.bookmarks),
          BottomNavigationBarItem(
            label: i18n.search,
            icon: const Icon(Icons.search_outlined),
          )
        ],
      ),
    );
  }
}
