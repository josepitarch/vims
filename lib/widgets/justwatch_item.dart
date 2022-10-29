import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/utils/justwatch.dart';

class JustwatchItem extends StatelessWidget {
  final Platform platform;

  const JustwatchItem({Key? key, required this.platform}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: change size of asset
    String asset = '';
    JustwatchAssets.justwatchAssets.forEach((key, value) {
      if (value.contains(platform.name.toLowerCase())) {
        asset = key;
      }
    });

    return asset.isNotEmpty
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/justwatch/$asset.jpg',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
          )
        : const SizedBox();
  }
}
