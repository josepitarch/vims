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
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        //selectedItemColor: Colors.orange[600],
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 16,
        unselectedFontSize: 14,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: (index) async {
          bool canVibrate = await Vibrate.canVibrate;

          if (canVibrate) {
            Vibrate.feedback(FeedbackType.medium);
          }
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.home,
            icon: const Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.top,
            icon: const Icon(Icons.list_alt_sharp),
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.bookmark),
              label: AppLocalizations.of(context)!.bookmarks),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.search,
            icon: const Icon(Icons.search_outlined),
          )
        ],
      ),
    );
  }
}
