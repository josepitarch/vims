import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scrapper_filmaffinity/providers/search_movie_provider.dart';

class InputDecorations {
  static InputDecoration searchMovieDecoration(AppLocalizations i18n,
      TextEditingController controller, SearchMovieProvider provider) {
    return InputDecoration(
      prefixIcon: const Icon(Icons.search),
      hintText: i18n.search_movie,
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
            controller.clear;
            provider.clearSearch();
          }
        },
        icon: const Icon(Icons.clear),
      ),
    );
  }
}
