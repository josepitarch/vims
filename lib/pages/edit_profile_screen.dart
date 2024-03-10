import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vims/constants/ui/assets.dart';
import 'package:vims/services/cloudinary/cloudinary.dart';
import 'package:vims/utils/snackbar.dart';
import 'package:vims/widgets/user_info_profile.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  late String? userName;
  late String? imagePath;
  late TextEditingController _controller;

  @override
  void initState() {
    userName = user.displayName;
    imagePath = user.photoURL;
    _controller = TextEditingController(text: userName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            userName: user.displayName ?? '',
            isVerified: user.emailVerified,
            imagePath: imagePath ?? Assets.NO_IMAGE,
            isEdit: true,
            onClicked: () async {
              final pickedImage =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedImage == null) return;

              setState(() {
                imagePath = pickedImage.path;
              });
            },
          ),
          const SizedBox(height: 24),
          Text(
            i18n.photo_profile_scope,
            textAlign: TextAlign.center,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 24),
          TextField(
            decoration: InputDecoration(
              labelText: i18n.your_name,
            ),
            controller: _controller,
            onChanged: (value) {
              setState(() {
                userName = value;
              });
            },
          ),
          const SizedBox(height: 24),
          _SaveButton(
              userId: user.uid, userName: userName, imagePath: imagePath),
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final String userId;
  final String? userName;
  final String? imagePath;
  const _SaveButton(
      {required this.userId, required this.userName, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;

    return ElevatedButton(
      child: Text(i18n.save),
      onPressed: () async {
        if (imagePath != FirebaseAuth.instance.currentUser!.photoURL) {
          postPhotoProfile(imagePath!, userId)
              .then((value) =>
                  FirebaseAuth.instance.currentUser!.updatePhotoURL(value))
              .catchError((error) =>
                  SnackBarUtils.show(context, i18n.error_update_photo_profile));
        }

        if (userName != FirebaseAuth.instance.currentUser!.displayName) {
          FirebaseAuth.instance.currentUser!.updateDisplayName(userName);
        }

        Navigator.of(context).pop();
      },
    );
  }
}
