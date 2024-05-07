import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class UserMenuOptions extends StatelessWidget {
  const UserMenuOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    final options = [
      {
        'title': i18n.my_reviews,
        'icon': Icons.rate_review,
        'route': '/user-reviews'
      },
      {
        'title': i18n.my_bookmarks,
        'icon': Icons.bookmark,
        'route': '/bookmarks'
      }
    ];

    return Expanded(
      child: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(options[index]['icon'] as IconData),
              title: Text(options[index]['title'] as String),
              onTap: () {
                final url = options[index]['route'] as String;
                context.push(url);
              },
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: 2),
    );
  }
}
