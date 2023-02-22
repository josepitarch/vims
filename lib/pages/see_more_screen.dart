import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vims/enums/title_sections.dart';
import 'package:vims/models/section.dart';
import 'package:vims/providers/see_more_provider.dart';
import 'package:vims/shimmer/see_more_shimmer.dart';
import 'package:vims/widgets/section_movie.dart';
import 'package:vims/widgets/handle_error.dart';

class SeeMore extends StatelessWidget {
  const SeeMore({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SeeMoreProvider>(builder: (_, provider, __) {
      final title = ModalRoute.of(context)!.settings.arguments as String;
      final String titleEnum = TitleSectionEnum.getName(title);

      onRefreshError() => provider.onRefreshError(titleEnum);

      if (provider.errors[titleEnum] != null)
        return HandleError(
            provider.errors[titleEnum], onRefreshError);

      Widget body;
      if (provider.seeMore[titleEnum] == null) {
        provider.getSeeMore(titleEnum);
        body = SeeMoreShimmer(title: title, height: 160, width: 120);
      } else {
        body = _Body(moviesSection: provider.seeMore[titleEnum]!);
      }

      return Scaffold(
          appBar: AppBar(
            title: Text(title, style: Theme.of(context).textTheme.headline2),
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
