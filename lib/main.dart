import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:vims/l10n/l10n.dart';
import 'package:vims/pages/actor_screen.dart';
import 'package:vims/pages/movie_screen.dart';
import 'package:vims/pages/section_screen.dart';
import 'package:vims/providers/implementation/actor_profile_provider.dart';
import 'package:vims/providers/implementation/bookmark_movies_provider.dart';
import 'package:vims/providers/implementation/movie_provider.dart';
import 'package:vims/providers/implementation/search_actor_provider.dart';
import 'package:vims/providers/implementation/search_movie_provider.dart';
import 'package:vims/providers/implementation/search_provider.dart';
import 'package:vims/providers/implementation/sections_provider.dart';
import 'package:vims/providers/implementation/see_more_provider.dart';
import 'package:vims/providers/implementation/top_movies_provider.dart';
import 'package:vims/ui/material_theme.dart';
import 'package:vims/widgets/navigation_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});
  @override
  Widget build(BuildContext context) {
    //Locale locale = WidgetsBinding.instance.window.locale;

    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => SectionsProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => TopMoviesProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => MovieProvider(), lazy: true),
      ChangeNotifierProvider(create: (_) => SearchProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => SearchMovieProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => SearchActorProvider(), lazy: false),
      ChangeNotifierProvider(
          create: (_) => BookmarkMoviesProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => SectionProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => ActorProfileProvider(), lazy: true)
    ], child: const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          'home': (_) => const HomeScreen(),
          'details': (_) => const MovieScreen(),
          'section': (_) => const SectionScreen(),
          'actor': (_) => const ActorScreen()
        },
        theme: MaterialTheme.materialTheme);
  }
}
