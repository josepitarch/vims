import 'package:flutter/material.dart';
import 'package:vims/models/filters.dart';

class PlatformItem extends StatefulWidget {
  final String assetName;
  final Filters filters;
  bool isSelected;

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
  onTap() => setState(() {
        widget.isSelected = !widget.isSelected;
        final index = widget.filters.platforms.indexOf(widget.assetName);
        if (index == -1) {
          widget.filters.platforms.add(widget.assetName);
        } else {
          widget.filters.platforms.removeAt(index);
        }
      });

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Stack(children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/justwatch/${widget.assetName}.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ),
        if (!widget.isSelected)
          Container(
            height: height * 0.06,
            width: height * 0.06,
            constraints: const BoxConstraints(maxHeight: 65, maxWidth: 65),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.65),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
      ]),
    );
  }
}
