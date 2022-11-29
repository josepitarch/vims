import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:scrapper_filmaffinity/utils/asset_flags.dart';

class Flag extends StatelessWidget {
  final String country;
  final String flag;
  const Flag({required this.flag, required this.country, super.key});

  @override
  Widget build(BuildContext context) {
    String aux = '';
    String countryNormalize = removeDiacritics(country.trim().toLowerCase());

    FlagsAssets.flags.forEach((key, value) {
      if (value.contains(countryNormalize)) {
        aux = key;
      }
    });

    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: aux.isEmpty ? _NetworkFlag(flag) : _AssetFlag(aux));
  }
}

class _AssetFlag extends StatelessWidget {
  final String flag;
  const _AssetFlag(this.flag);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/flags/$flag.png',
      width: 30,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const SizedBox(),
    );
  }
}

class _NetworkFlag extends StatelessWidget {
  final String flag;
  const _NetworkFlag(this.flag);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      flag,
      width: 30,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const SizedBox(),
    );
  }
}
