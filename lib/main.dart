import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/database/bookmark_movies_database.dart';
import 'package:scrapper_filmaffinity/database/history_search_database.dart';
import 'package:scrapper_filmaffinity/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scrapper_filmaffinity/pages/bookmark_movies_screen.dart';
import 'package:scrapper_filmaffinity/pages/search_movie.dart';

import 'package:scrapper_filmaffinity/widgets/navigation_bottom_bar.dart';
import 'package:scrapper_filmaffinity/pages/details_movie_screen.dart';
import 'package:scrapper_filmaffinity/providers/favorite_movies_provider.dart';
import 'package:scrapper_filmaffinity/providers/homepage_provider.dart';
import 'package:scrapper_filmaffinity/providers/search_movie_provider.dart';
import 'package:scrapper_filmaffinity/providers/top_movies_provider.dart';
import 'package:scrapper_filmaffinity/ui/text_theme_custom.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  BookmarkMoviesDatabase.initDatabase();
  HistorySearchDatabase.initDatabase();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Locale locale = WidgetsBinding.instance.window.locale;
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => HomepageProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => SearchMovieProvider(), lazy: false),
      ChangeNotifierProvider(
          create: (_) => FavoriteMovieProvider(), lazy: false),
      ChangeNotifierProvider(
          create: (_) => TopMoviesProvider(locale.languageCode), lazy: false)
    ], child: const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Películas',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L10n.l10n,
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          'home': (_) => const NavigatorBottomBarApp(),
          'details': (_) => const DetailsMovieScreen(),
          'bookmark': (_) => const BookmarkMoviesScreen(),
          'search': (_) => const SearchMovieScreen(),
        },
        theme: ThemeData.dark().copyWith(
          useMaterial3: true,
          primaryColor: Colors.orange,
          primaryColorDark: Colors.orange,
          splashColor: Colors.orange,
          textTheme: const TextTheme(
            headline3: TextThemeCustom.headline3,
            headline5: TextThemeCustom.headline5,
            bodyText1: TextThemeCustom.bodyText1,
            bodyText2: TextThemeCustom.bodyText2,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: Colors.grey.shade200,
            backgroundColor: Colors.orange.shade400,
            elevation: 0,
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Colors.red,
            textTheme: ButtonTextTheme.normal,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.black.withOpacity(0.2),
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ));
  }
}
