import 'package:flutter/material.dart';
import 'package:vims/models/filters.dart';

class PlatformItem extends StatefulWidget {
  final String assetName;
  bool isSelected;
  final Filters filters;

  PlatformItem({
    required this.assetName,
    required this.isSelected,
    required this.filters,
    super.key,
  });

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
        if (!widget.isSelected)
          SizedBox(
            height: 50,
            width: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.black.withOpacity(0.65),
              ),
            ),
          ),
      ]),
      onTap: () => setState(() {
        widget.isSelected = !widget.isSelected;
        final index = widget.filters.platforms.indexOf(widget.assetName);
        if (index == -1) {
          widget.filters.platforms.add(widget.assetName);
        } else {
          widget.filters.platforms.removeAt(index);
        }
      }),
    );
  }
}
