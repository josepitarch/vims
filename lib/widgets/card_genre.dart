import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vims/models/enums/genres.dart';
import 'package:vims/models/filters.dart';

class CardGenre extends StatefulWidget {
  final String genre;
  bool isSelected;
  final Filters filters;

  CardGenre(
      {required this.genre,
      required this.isSelected,
      required this.filters,
      super.key});

  @override
  State<CardGenre> createState() => _CardGenreState();
}

class _CardGenreState extends State<CardGenre> {
  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    final Map<String, String> genres = {
      Genres.action.value: i18n.action,
      Genres.adventure.value: i18n.adventure,
      Genres.comedy.value: i18n.comedy,
      Genres.drama.value: i18n.drama,
      Genres.terror.value: i18n.terror,
      Genres.musical.value: i18n.musical,
      Genres.romance.value: i18n.romance,
      Genres.war.value: i18n.war,
      Genres.thriller.value: i18n.thriller,
      Genres.mystery.value: i18n.mystery,
      Genres.western.value: i18n.western,
      Genres.kids.value: i18n.kids,
    };

    // TODO: refactor setState
    return TextButton(
      onPressed: () {
        setState(() {
          widget.isSelected = !widget.isSelected;
          final index = widget.filters.genres.indexOf(widget.genre);
          if (index == -1) {
            widget.filters.genres.add(widget.genre);
          } else {
            widget.filters.genres.removeAt(index);
          }
        });
      },
      style: TextButton.styleFrom(
        foregroundColor: widget.isSelected ? Colors.white : Colors.orange,
        backgroundColor: widget.isSelected ? Colors.orange : Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
      child: Text(genres[widget.genre]!),
    );
  }
}
