import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/providers/homepage_provider.dart';
import 'package:scrapper_filmaffinity/providers/top_movies_provider.dart';
import 'package:scrapper_filmaffinity/widgets/material_design_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeoutError extends StatelessWidget {
  const TimeoutError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final HomepageProvider homepageProvider =
        Provider.of<HomepageProvider>(context, listen: false);
    final TopMoviesProvider topMoviesProvider =
        Provider.of<TopMoviesProvider>(context, listen: false);

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(MaterialDesignIcons.emoticonConfusedOutline,
            size: 100, color: Colors.white),
        const SizedBox(height: 20),
        Text(localization.timeout_error,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6),
        TextButton(
            onPressed: () {
              homepageProvider.onRefresh();
              topMoviesProvider.onRefresh();
            },
            child: Text(localization.retry))
      ],
    ));
  }
}
