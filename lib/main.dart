import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:provider/provider.dart';

import 'package:vims/database/bookmark_movies_database.dart';
import 'package:vims/database/history_search_database.dart';
import 'package:vims/l10n/l10n.dart';
import 'package:vims/pages/details_movie_screen.dart';
import 'package:vims/pages/see_more_screen.dart';
import 'package:vims/providers/bookmark_movies_provider.dart';
import 'package:vims/providers/details_movie_provider.dart';
import 'package:vims/providers/homepage_provider.dart';
import 'package:vims/providers/search_movie_provider.dart';
import 'package:vims/providers/top_movies_provider.dart';
import 'package:vims/ui/material_theme.dart';
import 'package:vims/widgets/navigation_bottom_bar.dart';

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
    //Locale locale = WidgetsBinding.instance.window.locale;
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => HomepageProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => TopMoviesProvider(), lazy: false),
      ChangeNotifierProvider(
          create: (_) => DetailsMovieProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => SearchMovieProvider(), lazy: false),
      ChangeNotifierProvider(
          create: (_) => BookmarkMoviesProvider(), lazy: false)
    ], child: const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.grey[900],
        systemNavigationBarColor: Colors.black.withOpacity(0.9)));

    return MaterialApp(
        title: 'Vims',
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        localeResolutionCallback: L10n.localeResolutionCallback,
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          'home': (_) => const NavigatorBottomBarApp(),
          'details': (_) => const DetailsMovieScreen(),
          'see_more': (_) => const SeeMore(),
        },
        theme: MaterialTheme.materialTheme);
  }
}
