import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vims/constants/ui/search_movie_placeholder.dart';
import 'package:vims/constants/ui/search_person_placeholder.dart';
import 'package:vims/providers/implementation/search_provider.dart';

class InputDecorations {
  static InputDecoration searchDecoration(AppLocalizations i18n,
      void Function() onPressed, SearchProvider provider) {
    final List<String> placeholder = provider.tabIndex == 0
        ? SEARCH_MOVIES_PLACEHOLDER
        : SEARCH_PERSON_PLACEHOLDER;

    final int random = Random().nextInt(placeholder.length);

    return InputDecoration(
      prefixIcon: const Icon(Icons.search),
      hintStyle: const TextStyle(fontStyle: FontStyle.italic),
      hintText: '${placeholder[random]}...',
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(
          color: Colors.orange,
          width: 2.0,
        ),
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.orange)),
      suffixIcon: IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.clear),
      ),
    );
  }
}
