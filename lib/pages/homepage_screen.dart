import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/pages/favorite_movies_screen.dart';
import 'package:scrapper_filmaffinity/pages/top_movies_screen.dart';
import 'package:scrapper_filmaffinity/search/search_movie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scrapper_filmaffinity/widgets/section_list.dart';
import 'package:scrapper_filmaffinity/widgets/shimmer/homepage_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    const SectionList(),
    Container(),
    const FavouritesMovies(),
    const TopMoviesScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange[600],
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 16,
        unselectedFontSize: 14,
        onTap: (index) {
          setState(() {
            if (index == 1) {
              index = 0;
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(context: context),
              );
            }
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.home,
            icon: const Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.search,
            icon: const Icon(Icons.search_outlined),
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.hourglass_empty_rounded),
              label: AppLocalizations.of(context)!.favorites),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.top,
            icon: const Icon(Icons.list_alt_sharp),
          ),
        ],
      ),
    );
  }
}
