import 'package:flutter/material.dart';

//ignore: must_be_immutable
class GenreListTitle extends StatelessWidget {
  final String genre;
  bool isSelected;
  final Function onTap;

  GenreListTitle({
    Key? key,
    required this.genre,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);



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
