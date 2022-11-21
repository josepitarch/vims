import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DetailsMovieShimmer extends StatelessWidget {
  const DetailsMovieShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer.fromColors(
        baseColor: Colors.black,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HeaderShimmer(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _TitleShimmer(),
                    SizedBox(height: 7),
                    _DirectorShimmer(),
                    _Box(),
                    _CastShimmer(),
                    _CastShimmer(),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderShimmer extends StatelessWidget {
  const _HeaderShimmer({Key? key}) : super(key: key);

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
  const _TitleShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      height: 25,
      width: 180,
    );
  }
}

class _DirectorShimmer extends StatelessWidget {
  const _DirectorShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      height: 25,
      width: 130,
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 13),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      height: 50,
      width: MediaQuery.of(context).size.width * 0.9,
    );
  }
}

class _CastShimmer extends StatelessWidget {
  const _CastShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            height: 30,
            width: 100,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          height: 70,
          width: double.infinity,
        ),
      ],
    );
  }
}

class _SynopsisShimmer extends StatelessWidget {
  const _SynopsisShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            height: 30,
            width: 100,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          height: 120,
          width: double.infinity,
        ),
      ],
    );
  }
}

class _JustwatchShimmer extends StatelessWidget {
  const _JustwatchShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                width: 70,
                height: 30,
              )
          ]),
        ),
        const SizedBox(
          height: 15,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Wrap(spacing: 15, runSpacing: 10, children: [
            for (int i = 0; i < 4; i++)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                ),
                width: 70,
                height: 75,
              )
          ]),
        ),
      ]),
    );
  }
}

class _ReviewsShimmer extends StatelessWidget {
  const _ReviewsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          height: 30,
          width: 100,
          color: Colors.grey[200],
        ),
        for (int i = 0; i < 3; i++)
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                ),
                height: 60,
                width: double.infinity,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    height: 20,
                    width: 140,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    height: 20,
                    width: 20,
                  ),
                ],
              )
            ],
          )
      ],
    );
  }
}
