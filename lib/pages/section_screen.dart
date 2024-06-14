import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vims/models/section.dart';
import 'package:vims/pages/error/error_screen.dart';
import 'package:vims/providers/implementation/section_provider.dart';
import 'package:vims/widgets/card_section.dart';
import 'package:vims/widgets/shimmer/section_screen_shimmer.dart';

class SectionScreen extends StatelessWidget {
  final String id;
  final String title;

  const SectionScreen({required this.id, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SectionProvider>(builder: (_, provider, __) {
      onRefreshError() => provider.onRefreshError(id);

      if (provider.errors[id] != null) {
        return ErrorScreen(provider.errors[id], onRefreshError);
      }

      Widget body;
      if (provider.data![id] == null) {
        provider.fetchSection(id);
        body = SectionShimmer(title: title, height: 190, width: 120);
      } else {
        body = _Body(moviesSection: provider.data![id]!);
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
                saveToCache: false,
              ))
          .toList(),
    );
  }
}
