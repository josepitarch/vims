import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistorySearch extends StatelessWidget {
  final Future<List<String>> Function() future;
  final Function(String) onTap;
  final VoidCallback onClear;
  const HistorySearch(
      {required this.future,
      required this.onTap,
      required this.onClear,
      super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();

          List<String> historySearch = snapshot.data as List<String>;

          if (historySearch.isEmpty) {
            return Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  child: Container(color: Colors.transparent),
                ));
          }

          return Expanded(
            child: Column(
              children: [
                ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    shrinkWrap: true,
                    children: [
                      ...historySearch.map((history) {
                        return ListTile(
                          leading: const Icon(Icons.history),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              size: 22, color: Colors.grey),
                          title: Text(history,
                              style: Theme.of(context).textTheme.bodyLarge),
                          onTap: () => onTap(history),
                        );
                      }),
                    ]),
                _DeleteSearchersButton(onPressed: onClear),
                Flexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () =>
                          FocusScope.of(context).requestFocus(FocusNode()),
                      child: Container(color: Colors.transparent),
                    ))
              ],
            ),
          );
        });
  }
}

class _DeleteSearchersButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _DeleteSearchersButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations i18n = AppLocalizations.of(context)!;
    final Text text =
        Text(i18n.delete_all_searchers, style: _textStyle(context));
    return Theme.of(context).platform == TargetPlatform.android
        ? MaterialButton(onPressed: onPressed, child: text)
        : CupertinoButton(onPressed: onPressed, child: text);
  }

  _textStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.red);
  }
}
