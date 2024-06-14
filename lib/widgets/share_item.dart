import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vims/models/enums/share_page.dart';

class ShareItem extends StatelessWidget {
  final String subject;
  final SharePage sharePage;
  final int id;
  const ShareItem(
      {required this.subject,
      required this.sharePage,
      required this.id,
      super.key});

  @override
  Widget build(BuildContext context) {
    // final showShareButton =
    //     FirebaseRemoteConfig.instance.getBool("show_share_button");
    // if (!showShareButton) {
    //   return const SizedBox.shrink();
    // }

    // final shareUrl = sharePage == SharePage.MOVIE
    //     ? 'https://vims.app/movie/$id'
    //     : 'https://vims.app/profile/$id';
    // return IconButton(
    //     onPressed: () async =>
    //         await Share.share(shareUrl, subject: 'Compartir $subject'),
    //     icon: const Icon(Icons.share));

    return FutureBuilder(
        future: FirebaseRemoteConfig.instance.fetchAndActivate(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          final showShareButton =
              FirebaseRemoteConfig.instance.getBool("show_share_button");
          if (!showShareButton) {
            return const SizedBox.shrink();
          }
          final shareUrl = sharePage == SharePage.MOVIE
              ? 'https://vims.app/movie/$id'
              : 'https://vims.app/profile/$id';
          return IconButton(
            onPressed: () async =>
                await Share.share(shareUrl, subject: 'Compartir $subject'),
            icon: const Icon(Icons.share),
          );
        });
  }
}
