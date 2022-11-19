import 'dart:io' as io show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:scrapper_filmaffinity/models/section.dart';
import 'package:scrapper_filmaffinity/providers/homepage_provider.dart';
import 'package:scrapper_filmaffinity/shimmer/sections_shimmer.dart';
import 'package:scrapper_filmaffinity/widgets/pull_refresh_android.dart';
import 'package:scrapper_filmaffinity/widgets/pull_refresh_ios.dart';
import 'package:scrapper_filmaffinity/widgets/timeout_error.dart';
import 'package:scrapper_filmaffinity/widgets/title_section.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({Key? key}) : super(key: key);

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen>
    with WidgetsBindingObserver {
  @override
  initState() {
    checkIfNeedRefresh(context);
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkIfNeedRefresh(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomepageProvider>(builder: (_, provider, __) {
      if (provider.existsError) {
        return TimeoutError(onPressed: () => provider.onRefresh());
      }

      Widget body = SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(children: [
          ...provider.sections
              .map((section) => _Section(section: section))
              .toList(),
          const SizedBox(height: 30),
        ]),
      ));

      if (provider.isLoading) return const SectionsShimmer();

      return io.Platform.isAndroid
          ? PullRefreshAndroid(
              onRefresh: () => provider.onRefresh(), child: body)
          : PullRefreshIOS(onRefresh: () => provider.onRefresh(), child: body);
    });
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

void checkIfNeedRefresh(BuildContext context) {
  final String timeToRefresh = dotenv.env['TIME_REFRESH_HOMEPAGE']!;

  final provider = Provider.of<HomepageProvider>(context, listen: false);
  final Duration difference = DateTime.now().difference(provider.lastUpdate);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (difference.inHours >= int.parse(timeToRefresh)) provider.onRefresh();
  });
}

class _Section extends StatelessWidget {
  final Section section;

  const _Section({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: TitleSection(title: section.title),
        ),
        SizedBox(
          height: 210,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 12),
              ...section.movies
                  .map((movie) =>
                      _SectionMovie(film: movie, sectionTitle: section.title))
                  .toList(),
            ],
          ),
        )
      ],
    );
  }
}

class _SectionMovie extends StatelessWidget {
  final MovieSection film;
  final String sectionTitle;
  const _SectionMovie(
      {Key? key, required this.film, required this.sectionTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double width = 120;
    const double height = 190;
    final String heroTag = film.id + sectionTitle;

    return GestureDetector(
      onTap: () {
        Map<String, dynamic> arguments = {'id': film.id, 'heroTag': heroTag};
        Navigator.pushNamed(context, 'details', arguments: arguments);
      },
      child: Container(
          margin: const EdgeInsets.only(right: 15),
          width: width,
          height: height,
          child: Column(children: [
            Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    FadeInImage(
                        placeholder: const AssetImage('assets/loading.gif'),
                        image: NetworkImage(film.image),
                        width: width,
                        height: height - 30,
                        fit: BoxFit.cover),
                    Container(
                      height: 40,
                      width: double.infinity,
                      color: Colors.orange.withOpacity(0.8),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          film.premiereDay,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              film.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            )
          ])),
    );
  }
}
