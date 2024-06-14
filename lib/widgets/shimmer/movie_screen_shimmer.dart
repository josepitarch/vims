import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MovieScreenShimmer extends StatelessWidget {
  const MovieScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).removePadding(removeTop: true);
    return Scaffold(
      body: Shimmer.fromColors(
        baseColor: Colors.black,
        highlightColor: Colors.grey.shade100,
        child: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderShimmer(),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TitleShimmer(),
                      SizedBox(height: 7),
                      _DirectorShimmer(),
                      _BoxShimmer(),
                      _YearAndDurationShimmer(),
                      SizedBox(height: 7),
                      _SynopsisShimmer(),
                      SizedBox(height: 7),
                      _GenresShimmer(),
                      SizedBox(height: 7),
                      _CastShimmer(),
                      _PlatformsShimmer(),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderShimmer extends StatelessWidget {
  const _HeaderShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
    );
  }
}

class _TitleShimmer extends StatelessWidget {
  const _TitleShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      height: 30,
      width: 200,
    );
  }
}

class _DirectorShimmer extends StatelessWidget {
  const _DirectorShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      height: 20,
      width: 130,
    );
  }
}

class _BoxShimmer extends StatelessWidget {
  const _BoxShimmer();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        height: 50,
      ),
    );
  }
}

class _YearAndDurationShimmer extends StatelessWidget {
  const _YearAndDurationShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      height: 20,
      width: 100,
    );
  }
}

class _SynopsisShimmer extends StatelessWidget {
  const _SynopsisShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          height: 180,
          width: double.infinity,
        ),
      ],
    );
  }
}

class _GenresShimmer extends StatelessWidget {
  const _GenresShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        height: 20,
        width: 100,
      ),
      const SizedBox(
        height: 10,
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        height: 40,
        width: 400,
      )
    ]);
  }
}

class _CastShimmer extends StatelessWidget {
  const _CastShimmer();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            height: 20,
            width: 100,
          ),
        ),
        SizedBox(
          height: 90,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                height: width <= 414 ? 65 : 80,
                width: width <= 414 ? 65 : 80,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PlatformsShimmer extends StatelessWidget {
  const _PlatformsShimmer();

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    final double height = widthScreen <= 414 ? 60 : 80;
    final double width = widthScreen <= 414 ? 60 : 70;

    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 10),
      child: Column(children: [
        Align(
          alignment: Alignment.topLeft,
          child: Wrap(spacing: 10, runSpacing: 10, children: [
            for (int i = 0; i < 3; i++)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                ),
                width: 90,
                height: 30,
              )
          ]),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: height,
          child: ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, __) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    width: width,
                    height: height,
                  )),
        ),
      ]),
    );
  }
}
