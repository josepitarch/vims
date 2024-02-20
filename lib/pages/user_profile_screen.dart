import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<AuthProvider> providers = [
      EmailAuthProvider(),
      GoogleProvider(clientId: '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')
    ];

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: providers,
            headerBuilder: (context, constraints, shrinkOffset) {
              return Image.asset(
                'assets/logo.png',
                width: 200,
                height: 300,
              );
            },
            subtitleBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
              );
            },
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  '',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
            showPasswordVisibilityToggle: true,
          );
        }

        return Scaffold(
          body: Column(
            children: [
              const _UserHeaderProfile(),
              const _UserMenuOptions(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                child: const Text('Sign out'),
              )
            ],
          ),
        );
      },
    );
  }
}

class _UserHeaderProfile extends StatelessWidget {
  const _UserHeaderProfile();

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hola,\n ${user?.displayName}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await FirebaseAuth.instance.currentUser?.updateDisplayName(
                  'Jose Luis',
                );
              },
            ),
          ],
        ));
  }
}

class _UserMenuOptions extends StatelessWidget {
  const _UserMenuOptions();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations i18n = AppLocalizations.of(context)!;
    final options = [
      {
        'title': i18n.my_reviews,
        'icon': Icons.rate_review,
        'route': 'user-reviews'
      },
      {'title': i18n.my_bookmarks, 'icon': Icons.bookmark, 'route': 'bookmarks'}
    ];

    return Expanded(
      child: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(options[index]['icon'] as IconData),
              title: Text(options[index]['title'] as String),
              onTap: () {
                Navigator.pushNamed(context, options[index]['route'] as String);
              },
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: 2),
    );
  }
}
