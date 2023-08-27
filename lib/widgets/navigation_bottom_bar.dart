import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:vims/pages/bookmark_movies_screen.dart';
import 'package:vims/pages/search_movie_screen.dart';
import 'package:vims/pages/sections_screen.dart';
import 'package:vims/pages/top_movies_screen.dart';

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
    final options = {
      'home': {i18n.home, Icons.home},
      'top': {i18n.top, Icons.list_alt_sharp},
      'bookmarks': {i18n.bookmarks, Icons.bookmark},
      'search': {i18n.search, Icons.search_outlined}
    };

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        currentIndex: _selectedIndex,
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
        items: options.entries
            .map((e) => BottomNavigationBarItem(
                label: e.value.elementAt(0) as String,
                icon: Icon(e.value.elementAt(1) as IconData)))
            .toList(),
      ),
    );
  }
}
