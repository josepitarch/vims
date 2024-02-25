import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserReviewDialog extends StatelessWidget {
  const UserReviewDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    String title = '';
    String content = '';

    return SafeArea(
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(10.0),
        titlePadding: const EdgeInsets.all(16.0),
        content: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 700, maxWidth: 650),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    onChanged: (value) {
                      title = value;
                    },
                    validator: (value) =>
                        value!.isEmpty ? i18n.mandatory_title_review : null,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: contentController,
                    onChanged: (value) {
                      content = value;
                    },
                    validator: (value) =>
                        value!.isEmpty ? i18n.mandatory_content_review : null,
                    maxLines: 15,
                    maxLength: 500,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(i18n.cancel),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, {'title': title, 'content': content});
              }
            },
            child: Text(i18n.publish),
          ),
        ],
      ),
    );
  }
}
