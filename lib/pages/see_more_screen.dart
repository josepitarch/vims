import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vims/models/section.dart';
import 'package:vims/providers/implementation/see_more_provider.dart';
import 'package:vims/shimmer/see_more_shimmer.dart';
import 'package:vims/widgets/handle_error.dart';
import 'package:vims/widgets/section_movie.dart';

class SeeMore extends StatelessWidget {
  const SeeMore({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SeeMoreProvider>(builder: (_, provider, __) {
      final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
      final String title = arguments['title'];
      final String code = arguments['code'];

      onRefreshError() => provider.onRefreshError(code);

      if (provider.errors[code] != null)
        return HandleError(provider.errors[code], onRefreshError);

      Widget body;
      if (provider.data[code] == null) {
        provider.getSeeMore(code);
        body = SeeMoreShimmer(title: title, height: 160, width: 120);
      } else {
        body = _Body(moviesSection: provider.data[code]!);
      }

      return Scaffold(
          appBar: AppBar(
            title:
                Text(title, style: Theme.of(context).textTheme.displayMedium),
          ),
          body: SafeArea(
            child: body,
          ));
    });
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
    required this.moviesSection,
  }) : super(key: key);

  final List<MovieSection> moviesSection;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.only(top: 15, left: 10),
      crossAxisCount: 3,
      childAspectRatio: 0.65,
      mainAxisSpacing: 10,
      children: moviesSection
          .map((movieSection) => SectionMovie(
              movieSection: movieSection,
              heroTag: movieSection.id.toString(),
              saveToCache: false,
              height: 160,
              width: 120))
          .toList(),
    );
  }
}
