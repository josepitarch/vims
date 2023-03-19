import 'package:flutter/material.dart';
import 'package:vims/models/suggestion.dart';
import 'package:vims/utils/custom_cache_manager.dart';
import 'package:vims/widgets/custom_image.dart';

class CardSuggestion extends StatelessWidget {
  final Suggestion suggestion;
  const CardSuggestion(this.suggestion, {super.key});

  @override
  Widget build(BuildContext context) {
    double height = 150.0;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Map<String, dynamic> arguments = {
          'id': suggestion.id,
          'movie': suggestion,
          'hasAllAttributes': false
        };
        Navigator.pushNamed(context, 'details', arguments: arguments);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        margin: const EdgeInsets.only(bottom: 20.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _Poster(height: height, suggestion: suggestion, saveToCache: false),
          Expanded(
            child: Container(
                height: height,
                margin: const EdgeInsets.only(left: 10, top: 15),
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      _Title(suggestion.title),
                      const SizedBox(height: 10.0),
                    ]),
                  ],
                )),
          ),
          SizedBox(
              height: height,
              child: const Icon(Icons.arrow_forward_ios_outlined,
                  size: 22, color: Colors.grey))
        ]),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  final double height;
  final Suggestion suggestion;
  final bool saveToCache;

  const _Poster({
    Key? key,
    required this.height,
    required this.suggestion,
    required this.saveToCache,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double width = 120.0;
    return Hero(
      tag: suggestion.id,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: CustomImage(
            url: suggestion.poster,
            width: width,
            height: height + 20,
            saveToCache: saveToCache,
            cacheManager: CustomCacheManager.cacheTinyImages),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  const _Title(
    this.title, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Text(
        title,
        style: Theme.of(context).textTheme.displaySmall,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}

class _Director extends StatelessWidget {
  final String? director;
  const _Director(
    this.director, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Text(
        director ?? '',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontStyle: FontStyle.italic,
              //color: Theme.of(context).colorScheme.secondary
            ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}
