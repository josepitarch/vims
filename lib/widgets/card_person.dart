import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vims/models/person.dart';
import 'package:vims/utils/custom_cache_manager.dart';
import 'package:vims/widgets/custom_image.dart';

class CardPerson extends StatelessWidget {
  final Person person;

  const CardPerson({required this.person, super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    onTap() => context.push(
        '/profile/${person.id}?name=${person.name}&image=${person.image?.mmed}');

    return Container(
      height: height * 0.23,
      margin: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 2), blurRadius: 1.0)
          ]),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        onTap: onTap,
        radius: 25,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Hero(
            tag: person.id,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: _Poster(
                id: person.id,
                poster: person.image?.mmed ?? '',
                saveToCache: true,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              person.name,
              style: Theme.of(context).textTheme.displaySmall,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          )
        ]),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  final int id;
  final String poster;
  final bool saveToCache;

  const _Poster({
    required this.id,
    required this.poster,
    required this.saveToCache,
  });

  @override
  Widget build(BuildContext context) {
    /*
    borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        bottomLeft: Radius.circular(25),
      ),*/
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: CustomImage(
          url: poster,
          saveToCache: saveToCache,
          cacheManager: CustomCacheManager.cacheTinyImages),
    );
  }
}
