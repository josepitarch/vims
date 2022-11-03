import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/enums/genres.dart';
import 'package:scrapper_filmaffinity/models/filters.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardGenre extends StatefulWidget {
  final Genres genre;
  bool isSelected;
  final Filters filters;

  CardGenre(
      {Key? key,
      required this.genre,
      required this.isSelected,
      required this.filters})
      : super(key: key);

  @override
  State<CardGenre> createState() => _CardGenreState();
}

class _CardGenreState extends State<CardGenre> {
  @override
  Widget build(BuildContext context) {
    //TODO: handle supported languages
    final i18n = AppLocalizations.of(context)!;
    return TextButton(
      onPressed: () {
        setState(() {
          widget.isSelected = !widget.isSelected;
          widget.filters.genres[widget.genre] = widget.isSelected;
        });
      },
      style: TextButton.styleFrom(
        foregroundColor: widget.isSelected ? Colors.white : Colors.orange,
        backgroundColor: widget.isSelected ? Colors.orange : Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
      child: Text(widget.genre.value[i18n.localeName]!),
    );
  }
}
