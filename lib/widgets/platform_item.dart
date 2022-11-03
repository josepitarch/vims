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
    return Stack(children: [
      SizedBox(
        height: 60,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(90),
          child: IconButton(
            icon: Image.asset('assets/justwatch/${widget.assetName}.jpg',
                fit: BoxFit.cover,
                height: 60,
                width: 60,
                errorBuilder: (_, __, ___) => const SizedBox()),
            onPressed: () {
              setState(() {
                widget.isSelected = !widget.isSelected;
                widget.filters.platforms[widget.assetName] = widget.isSelected;
              });
            },
          ),
        ),
      ),
      if (widget.isSelected)
        const Positioned(
            right: 0,
            bottom: 15,
            width: 20,
            height: 20,
            child: CircleAvatar(
                child: Icon(size: 10, Icons.check, color: Colors.white)))
    ]);
  }
}
