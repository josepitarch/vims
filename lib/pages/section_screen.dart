import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vims/models/section.dart';
import 'package:vims/pages/error/error_screen.dart';
import 'package:vims/providers/implementation/section_provider.dart';
import 'package:vims/widgets/card_section.dart';
import 'package:vims/widgets/shimmer/section_screen_shimmer.dart';

class SectionScreen extends StatelessWidget {
  const SectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SectionProvider>(builder: (_, provider, __) {
      final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
      final String title = arguments['title'];
      final String code = arguments['id'];

      onRefreshError() => provider.onRefreshError(code);

      if (provider.errors[code] != null) {
        return ErrorScreen(provider.errors[code], onRefreshError);
      }

      Widget body;
      if (provider.data![code] == null) {
        provider.fetchSection(code);
        body = SectionShimmer(title: title, height: 190, width: 120);
      } else {
        body = _Body(moviesSection: provider.data![code]!);
      }

      return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: SafeArea(
            child: body,
          ));
    });
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.moviesSection});

  final List<MovieSection> moviesSection;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.only(top: 15, left: 10),
      crossAxisCount: 3,
      childAspectRatio: 0.6,
      children: moviesSection
          .map((movieSection) => CardSection(
                movie: movieSection,
                heroTag: movieSection.id.toString(),
                saveToCache: false,
              ))
          .toList(),
    );
  }
}
