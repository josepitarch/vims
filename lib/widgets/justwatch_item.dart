import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/models/movie.dart';
import 'package:scrapper_filmaffinity/utils/asset_platforms.dart';
import 'package:url_launcher/url_launcher_string.dart';

class JustwatchItem extends StatelessWidget {
  final Platform platform;

  const JustwatchItem(this.platform, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String asset = '';

    PlatformAssets.justwatchAssets.forEach((key, value) {
      if (value.contains(platform.name.toLowerCase())) {
        asset = key;
      }
    });

    return GestureDetector(
        onTap: () =>
            launchUrlString(platform.url, mode: LaunchMode.externalApplication),
        child: Container(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: asset.isEmpty
                  ? _NetworkJustwatch(platform.icon)
                  : _AssetJustwatch(platform: platform, asset: asset)),
        ));
  }
}

class _AssetJustwatch extends StatelessWidget {
  final Platform platform;
  final String asset;

  const _AssetJustwatch({
    Key? key,
    required this.platform,
    required this.asset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/justwatch/$asset.jpg',
      fit: BoxFit.cover,
      height: 50,
      width: 50,
      errorBuilder: (_, __, ___) => const SizedBox(),
    );
  }
}

class _NetworkJustwatch extends StatelessWidget {
  final String icon;
  const _NetworkJustwatch(this.icon);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      icon,
      fit: BoxFit.cover,
      height: 50,
      width: 50,
      errorBuilder: (_, __, ___) => const SizedBox(),
    );
  }
}
