import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vims/constants/ui/assets.dart';
import 'package:vims/dialogs/email_no_verified_dialog.dart';
import 'package:vims/dialogs/email_verified_dialog.dart';

class ProfileWidget extends StatelessWidget {
  final String? userName;
  final bool isVerified;
  final String? imagePath;
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileWidget({
    super.key,
    this.imagePath,
    this.userName,
    required this.isVerified,
    this.isEdit = false,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    dynamic image;

    if (imagePath == null || imagePath!.isEmpty) {
      image = AssetImage(ASSETS['NO_IMAGE']!);
    } else {
      image = imagePath!.contains('https')
          ? NetworkImage(imagePath!)
          : FileImage(File(imagePath!));
    }
    return Column(
      children: [
        Stack(
          children: [
            ClipOval(
              child: Material(
                color: Colors.transparent,
                child: Ink.image(
                  image: FadeInImage(
                    placeholder: AssetImage(ASSETS['LOADING_ACTOR']!),
                    image: image as ImageProvider,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        Image.asset(ASSETS['NO_IMAGE']!,
                            fit: BoxFit.cover, width: 128, height: 128),
                  ).image,
                  fit: BoxFit.cover,
                  width: 128,
                  height: 128,
                  child: InkWell(onTap: onClicked),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 4,
              child: buildEditIcon(color),
            ),
          ],
        ),
        _EmailVerification(userName: userName, isVerified: isVerified),
      ],
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            isEdit ? Icons.add_a_photo : Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}

class _EmailVerification extends StatelessWidget {
  final String? userName;
  final bool isVerified;
  const _EmailVerification({
    required this.userName,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          userName ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        isVerified
            ? IconButton(
                icon: const Icon(Icons.verified),
                color: Colors.green,
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => const EmailVerifiedDialog(),
                ),
              )
            : IconButton(
                icon: const Icon(Icons.warning_amber_rounded),
                color: Colors.yellow,
                onPressed: () => showDialog(
                            context: context,
                            builder: (context) => const EmailNoVerifiedDialog())
                        .then((value) {
                      if (value == true) {
                        FirebaseAuth.instance.currentUser!
                            .sendEmailVerification();
                      }
                    }))
      ],
    );
  }
}
