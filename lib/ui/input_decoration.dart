import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vims/constants/ui/search_movie_placeholder.dart';

import '../providers/implementation/search_movie_provider.dart';

class InputDecorations {
  static InputDecoration searchMovieDecoration(AppLocalizations i18n,
      TextEditingController controller, SearchMovieProvider provider) {
    final int length = SEARCH_MOVIES_PLACEHOLDER.length;
    final int random = Random().nextInt(length);
    return InputDecoration(
      prefixIcon: const Icon(Icons.search),
      hintStyle: const TextStyle(fontStyle: FontStyle.italic),
      hintText: '${SEARCH_MOVIES_PLACEHOLDER[random]}...',
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
        onPressed: () {
          if (controller.text.isNotEmpty) {
            controller.text = '';
            provider.clearSearch();
          }
        },
        icon: const Icon(Icons.clear),
      ),
    );
  }
}
