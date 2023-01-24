import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vims/enums/title_sections.dart';
import 'package:vims/providers/homepage_provider.dart';
import 'package:vims/shimmer/see_more_shimmer.dart';
import 'package:vims/widgets/section_movie.dart';
import 'package:vims/widgets/handle_error.dart';
import 'package:collection/collection.dart';

class SeeMore extends StatelessWidget {
  const SeeMore({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomepageProvider>(context, listen: true);
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

    if (provider.seeMore[titleEnum] == null) {
      provider.getSeeMore(titleEnum, isRelease);
      return SeeMoreShimmer(title: title, height: 160, width: 120);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 0.65,
            mainAxisSpacing: 10,
            children: provider.seeMore[titleEnum]!
                .map((movieSection) => SectionMovie(
                    movieSection: movieSection,
                    heroTag: movieSection.id,
                    saveToCache: false,
                    height: 160,
                    width: 120))
                .toList(),
          ),
        ),
      ),
    );
  }
}
