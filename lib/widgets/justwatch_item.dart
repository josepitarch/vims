import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:vims/models/enums/platforms.dart';
import 'package:vims/models/movie.dart';

class JustwatchItem extends StatelessWidget {
  final Platform platform;
  final double height;
  final double width;

  const JustwatchItem(this.platform,
      {required this.height, required this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: _Icon(platform, height: height, width: width)),
    );
  }
}

class _Icon extends StatelessWidget {
  final Platform platform;
  final double height;
  final double width;
  const _Icon(this.platform, {required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    Platforms? asset = Platforms.values.firstWhereOrNull(
        (element) => element.value.contains(platform.name.toLowerCase()));

    if (asset == null) {
      return Image.network(platform.icon,
          fit: BoxFit.cover,
          height: height,
          width: width,
          errorBuilder: (_, __, ___) => const SizedBox.shrink());
    }

    return Image.asset(
      'assets/justwatch/${asset.name}.jpg',
      fit: BoxFit.cover,
      height: height,
      width: width,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  }
}
