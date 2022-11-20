import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/utils/justwatch.dart';
import 'package:url_launcher/url_launcher_string.dart';

class JustwatchItem extends StatelessWidget {
  final Platform platform;

  const JustwatchItem({Key? key, required this.platform}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String asset = '';

    JustwatchAssets.justwatchAssets.forEach((key, value) {
      if (value.contains(platform.name.toLowerCase())) {
        asset = key;
      }
    });

    return asset.isNotEmpty
        ? InkWell(
            onTap: (() {
              launchUrlString(platform.url,
                  mode: LaunchMode.externalApplication);
            }),
            child: Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/justwatch/$asset.jpg',
                  fit: BoxFit.cover,
                  height: 50,
                  width: 50,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
