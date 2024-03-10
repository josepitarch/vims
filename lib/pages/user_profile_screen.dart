import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, User;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vims/constants/ui/assets.dart';
import 'package:vims/dialogs/delete_account_dialog.dart';
import 'package:vims/services/api/user_service.dart';
import 'package:vims/utils/snackbar.dart';
import 'package:vims/widgets/user_info_profile.dart';
import 'package:vims/widgets/user_menu_options.dart';

final GOOGLE_CLIENT_ID = dotenv.env['GOOGLE_CLIENT_ID'];

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    final googleClientId = Theme.of(context).platform == TargetPlatform.android
        ? dotenv.env['GOOGLE_CLIENT_ID_ANDROID']
        : dotenv.env['GOOGLE_CLIENT_ID_IOS'];

    final List<AuthProvider> providers = [
      EmailAuthProvider(),
      GoogleProvider(clientId: googleClientId!),
      if (Theme.of(context).platform == TargetPlatform.iOS) AppleProvider()
    ];

    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (FirebaseAuth.instance.currentUser == null &&
              snapshot.data == null) {
            return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: SignInScreen(
                providers: providers,
                headerMaxExtent: MediaQuery.of(context).size.height * 0.40,
                headerBuilder: (context, constraints, shrinkOffset) {
                  return ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 1.75, sigmaY: 0),
                      child: Image.asset(
                        Assets.MOVIES_WALLPAPER,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.40,
                        fit: BoxFit.cover,
                      ));
                },
                showPasswordVisibilityToggle: true,
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(i18n.title_profile_page),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete_forever),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const DeleteAccountDialog(),
                  ).then((value) async {
                    if (value == true) {
                      final uid = FirebaseAuth.instance.currentUser!.uid;
                      FirebaseAuth.instance.currentUser!.delete().then((value) {
                        deleteAccount(uid);
                      }).catchError((error) {
                        if (error is FirebaseAuthException) {
                          if (error.code == 'requires-recent-login') {
                            SnackBarUtils.show(context, i18n.required_relogin);
                          }
                        }
                      });
                    }
                  }),
                )
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StreamBuilder<User?>(
                          stream: FirebaseAuth.instance.userChanges(),
                          builder: (context, snapshot) {
                            final displayName =
                                snapshot.data?.displayName ?? '';
                            final emailVerified =
                                snapshot.data?.emailVerified ?? false;
                            final photoURL =
                                snapshot.data?.photoURL ?? Assets.NO_IMAGE;

                            return ProfileWidget(
                              userName: displayName,
                              isVerified: emailVerified,
                              imagePath: photoURL,
                              onClicked: () async {
                                Navigator.pushNamed(context, 'edit-profile');
                                setState(() {});
                              },
                            );
                          }),
                    ],
                  ),
                ),
                const UserMenuOptions(),
                TextButton.icon(
                  icon: const Icon(Icons.logout),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  label: Text(i18n.logout),
                ),
              ],
            ),
          );
        });
  }
}
