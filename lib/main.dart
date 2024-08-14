import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:vims/firebase_options.dart';
import 'package:vims/l10n/l10n.dart';
import 'package:vims/pages/bookmarks_screen.dart';
import 'package:vims/pages/edit_account_screen.dart';
import 'package:vims/pages/movie_screen.dart';
import 'package:vims/pages/profile_screen.dart';
import 'package:vims/pages/section_screen.dart';
import 'package:vims/pages/user_reviews_screen.dart';
import 'package:vims/providers/implementation/bookmarks_provider.dart';
import 'package:vims/providers/implementation/movie_provider.dart';
import 'package:vims/providers/implementation/profile_provider.dart';
import 'package:vims/providers/implementation/reviews_provider.dart';
import 'package:vims/providers/implementation/search_movie_provider.dart';
import 'package:vims/providers/implementation/search_person_provider.dart';
import 'package:vims/providers/implementation/search_provider.dart';
import 'package:vims/providers/implementation/section_provider.dart';
import 'package:vims/providers/implementation/sections_provider.dart';
import 'package:vims/providers/implementation/top_provider.dart';
import 'package:vims/pages/home_screen.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: const Duration(hours: 24),
  ));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const AppState()));
}

class AppState extends StatelessWidget {
  const AppState({super.key});
  @override
  Widget build(BuildContext context) {
    //Locale locale = WidgetsBinding.instance.window.locale;

    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => SectionsProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => TopMoviesProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => MovieProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => SearchProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => SearchMovieProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => SearchActorProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => BookmarksProvider(), lazy: true),
      ChangeNotifierProvider(create: (_) => SectionProvider(), lazy: true),
      ChangeNotifierProvider(create: (_) => ProfileProvider(), lazy: true),
      ChangeNotifierProvider(create: (_) => UserReviewsProvider(), lazy: true)
    ], child: const App());
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'Vims',
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        localeResolutionCallback: L10n.localeResolutionCallback,
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
        theme: ThemeData.dark().copyWith(
            primaryColor: Colors.orange,
            colorScheme: const ColorScheme.dark().copyWith(
              primary: Colors.orange,
              secondary: Colors.blue,
              onSecondary: Colors.grey.shade200,
            ),
            textTheme: MyTextTheme(context),
            appBarTheme: const AppBarTheme(
                centerTitle: true,
                titleTextStyle: TextStyle(
                    fontSize: 21,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w700)),
            scaffoldBackgroundColor: Colors.grey[900],
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              foregroundColor: Colors.grey.shade200,
              backgroundColor: Colors.orange.shade400,
              elevation: 0,
            ),
            buttonTheme: const ButtonThemeData(
              buttonColor: Colors.red,
              textTheme: ButtonTextTheme.normal,
            ),
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: Colors.black.withOpacity(0.2),
              indicatorColor: Colors.red,
              elevation: 0,
            ),
            inputDecorationTheme: InputDecorationTheme(
              prefixIconColor: Colors.grey,
              suffixIconColor: Colors.grey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.orange),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.red),
              ),
              labelStyle: const TextStyle(color: Colors.grey),
              hintStyle: const TextStyle(
                  fontStyle: FontStyle.italic, color: Colors.grey),
              errorStyle: const TextStyle(color: Colors.red),
            ),
            snackBarTheme: SnackBarThemeData(
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              contentTextStyle:
                  Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                      ),
            )));
  }
}

final _router = GoRouter(
  initialLocation: '/',
  onException: (context, state, router) => router.go('/'),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/movie/:id',
      builder: (context, state) =>
          MovieScreen(id: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/section/:id',
      builder: (context, state) => SectionScreen(
          id: state.pathParameters['id']!,
          title: state.uri.queryParameters['title']!),
    ),
    GoRoute(
      path: '/profile/:id',
      builder: (context, state) => ProfileScreen(
          id: int.parse(state.pathParameters['id']!),
          name: state.uri.queryParameters['name'],
          image: state.uri.queryParameters['image']),
    ),
    GoRoute(
      path: '/bookmarks',
      builder: (context, state) => const BookmarkMoviesScreen(),
    ),
    GoRoute(
      path: '/user-reviews',
      builder: (context, state) => const UserReviewsScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    )
  ],
);

TextTheme MyTextTheme(BuildContext context) {
  final List<int> breakpoints = [414, 768, 1024, 1280];
  double width = MediaQuery.of(context).size.width;

  double calculateFontSize(List<int> fontSizes) {
    if (width <= breakpoints[0]) return fontSizes[0].toDouble();
    return fontSizes[1].toDouble();
  }

  return TextTheme(
    displayLarge: TextStyle(
        fontSize: calculateFontSize([24, 27]),
        height: 1.2,
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.w700),
    displayMedium: TextStyle(
        fontSize: calculateFontSize([21, 24]),
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.w700),
    displaySmall: TextStyle(
        fontSize: calculateFontSize([17, 21]),
        height: 1.2,
        fontFamily: 'Lato',
        fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(
        fontSize: calculateFontSize([16, 19]),
        height: 1.2,
        fontFamily: 'Lato',
        fontWeight: FontWeight.w500),
    headlineSmall: TextStyle(
        fontSize: calculateFontSize([15, 18]),
        height: 1.2,
        fontFamily: 'Lato',
        fontWeight: FontWeight.normal),
    titleLarge: TextStyle(
        fontSize: calculateFontSize([17, 20]),
        fontFamily: 'Lato',
        fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(
        fontSize: calculateFontSize([16, 19]),
        fontFamily: 'Lato',
        fontWeight: FontWeight.normal),
    bodyMedium: TextStyle(
        fontSize: calculateFontSize([14, 17]),
        fontFamily: 'Lato',
        fontWeight: FontWeight.normal),
  );
}
