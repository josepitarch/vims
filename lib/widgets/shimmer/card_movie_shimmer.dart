import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardMovieShimmer extends StatelessWidget {
  final int total;

  const CardMovieShimmer({this.total = 10, super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations i18n = AppLocalizations.of(context)!;
    final double height = MediaQuery.of(context).size.height;

    return ListView.builder(
        itemCount: total,
        itemBuilder: (_, __) {
          return Shimmer.fromColors(
            baseColor: Colors.black,
            highlightColor: Colors.grey.shade100,
            child: Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 7.0, horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              ),
              height: height * 0.23,
              width: double.infinity,
            ),
          );
        });
  }
}
