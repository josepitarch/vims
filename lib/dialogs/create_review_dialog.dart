import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vims/models/enums/inclination.dart';

class UserReviewDialog extends StatelessWidget {
  const UserReviewDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    // final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Inclination inclination = Inclination.POSITIVE;
    String content = '';

    onInclinationChanged(Inclination value) {
      inclination = value;
    }

    return SafeArea(
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(10.0),
        titlePadding: const EdgeInsets.all(16.0),
        content: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 700, maxWidth: 650),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // TextFormField(
                  //   controller: titleController,
                  //   onChanged: (value) {
                  //     title = value;
                  //   },
                  //   validator: (value) =>
                  //       value!.isEmpty ? i18n.mandatory_title_review : null,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Título',
                  //     border: UnderlineInputBorder(
                  //         borderSide: BorderSide(color: Colors.orange)),
                  //     focusedBorder: UnderlineInputBorder(
                  //         borderSide: BorderSide(color: Colors.orange)),
                  //     enabledBorder: UnderlineInputBorder(
                  //         borderSide: BorderSide(color: Colors.grey)),
                  //     errorBorder: UnderlineInputBorder(
                  //         borderSide: BorderSide(color: Colors.red)),
                  //   ),
                  // ),
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
                  RadioListTileExample(onChanged: onInclinationChanged)
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
                Navigator.pop(
                    context, {'content': content, 'inclination': inclination});
              }
            },
            child: Text(i18n.publish),
          ),
        ],
      ),
    );
  }
}

class RadioListTileExample extends StatefulWidget {
  final Function(Inclination) onChanged;
  const RadioListTileExample({required this.onChanged, super.key});

  @override
  State<RadioListTileExample> createState() => _RadioListTileExampleState();
}

class _RadioListTileExampleState extends State<RadioListTileExample> {
  Inclination? _character = Inclination.POSITIVE;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 160, maxHeight: 100),
            child: RadioListTile.adaptive(
              title: const Text('Positive'),
              value: Inclination.POSITIVE,
              groupValue: _character,
              onChanged: (Inclination? value) {
                widget.onChanged(value!);
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 160, maxHeight: 100),
            child: RadioListTile.adaptive(
              title: const Text('Neutral'),
              value: Inclination.NEUTRAL,
              groupValue: _character,
              onChanged: (Inclination? value) {
                widget.onChanged(value!);
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 180, maxHeight: 100),
            child: RadioListTile.adaptive(
              title: const Text('Negative'),
              value: Inclination.NEGATIVE,
              groupValue: _character,
              onChanged: (Inclination? value) {
                widget.onChanged(value!);
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
