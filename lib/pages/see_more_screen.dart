import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vims/enums/title_sections.dart';
import 'package:vims/models/section.dart';
import 'package:vims/providers/homepage_provider.dart';
import 'package:vims/shimmer/see_more_shimmer.dart';
import 'package:vims/widgets/section_movie.dart';
import 'package:vims/widgets/handle_error.dart';
import 'package:collection/collection.dart';

class SeeMore extends StatelessWidget {
  const SeeMore({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomepageProvider>(context);
    final title = ModalRoute.of(context)!.settings.arguments as String;

    if (provider.error != null)
      return HandleError(provider.error!, provider.onRefresh);

    final String titleEnum = TitleSectionEnum.values
        .firstWhereOrNull((element) => element.value.contains(title))
        .toString()
        .split('.')
        .last;

    final bool isRelease =
        !TitleSectionEnum.coming_theaters.value.contains(title);

    Widget body;
    if (provider.seeMore[titleEnum] == null) {
      provider.getSeeMore(titleEnum, isRelease);
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
      ),
    );
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
              heroTag: movieSection.id,
              saveToCache: false,
              height: 160,
              width: 120))
          .toList(),
    );
  }
}
