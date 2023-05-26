import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DetailsMovieShimmer extends StatelessWidget {
  const DetailsMovieShimmer({Key? key}) : super(key: key);

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
                      _CastShimmer(),
                      _CastShimmer(),
                      _SynopsisShimmer(),
                      _JustwatchShimmer()
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
      height: 35,
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
      height: 20,
      width: 130,
    );
  }
}

class _BoxShimmer extends StatelessWidget {
  const _BoxShimmer({Key? key}) : super(key: key);

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
            height: 20,
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
            height: 20,
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
                height: 20,
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
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                width: 50,
                height: 50,
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
