import 'package:flutter/material.dart';

class GenreListTitle extends StatelessWidget {
  GenreListTitle({
    Key? key,
    required this.genre,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  final String genre;
  bool isSelected;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        genre,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.orange,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () => onTap(genre),
      trailing: isSelected
          ? const Icon(
              Icons.check,
              color: Colors.orange,
            )
          : null,
    );
  }
}
