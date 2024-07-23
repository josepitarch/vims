import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vims/pages/error/error_screen.dart';
import 'package:vims/providers/implementation/sections_provider.dart';
import 'package:vims/widgets/pull_refresh.dart';
import 'package:vims/widgets/section_widget.dart';
import 'package:vims/widgets/shimmer/sections_screen_shimmer.dart';

class SectionsScreen extends StatelessWidget {
  const SectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SectionsProvider provider = Provider.of(context, listen: true);

    if (provider.exception != null) {
      return ErrorScreen(provider.exception!, provider.onRefresh);
    }

    if (provider.isLoading) return const SectionsShimmer();

    final sections = provider.data!
        .map((section) => SectionWidget(section: section))
        .toList();

    return PullRefresh(
      children: sections,
      onRefresh: () {
        return provider.onRefresh();
      },
    );
  }
}
