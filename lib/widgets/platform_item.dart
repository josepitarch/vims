import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/models/filters.dart';

class PlatformItem extends StatefulWidget {
  final String assetName;
  bool isSelected;
  final Filters filters;

  PlatformItem({
    Key? key,
    required this.assetName,
    required this.isSelected,
    required this.filters,
  }) : super(key: key);

  @override
  State<PlatformItem> createState() => _PlatformItemState();
}

class _PlatformItemState extends State<PlatformItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/justwatch/${widget.assetName}.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(),
            ),
          ),
        ),
        if (widget.isSelected)
          const Positioned(
              right: 7,
              bottom: 0,
              width: 20,
              height: 20,
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(size: 13, Icons.check, color: Colors.black)))
      ]),
      onTap: () => setState(() {
        widget.isSelected = !widget.isSelected;
        widget.filters.platforms[widget.assetName] = widget.isSelected;
      }),
    );
  }
}
