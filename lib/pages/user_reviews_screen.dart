import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vims/dialogs/delete_review_dialog.dart';
import 'package:vims/providers/implementation/movie_provider.dart';
import 'package:vims/providers/implementation/reviews_provider.dart';
import 'package:vims/widgets/review_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserReviewsScreen extends StatelessWidget {
  const UserReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    final provider = Provider.of<UserReviewsProvider>(context);
    final reviews = provider.data!;

    return Scaffold(
        appBar: AppBar(
          title: Text(i18n.title_user_reviews_page),
        ),
        body: ListView(
            children: reviews
                .map((review) => InkWell(
                      onLongPress: () => showDialog(
                        context: context,
                        builder: (context) => const DeleteReviewDialog(),
                      ).then((value) {
                        if (value) {
                          provider.deleteReview(review);
                          context
                              .read<MovieProvider>()
                              .removeReview(review.movieId, review.id);
                        }
                      }),
                      child: ReviewItem(
                          title: review.title,
                          content: review.content,
                          author: '',
                          date: review.createdAt,
                          inclination: review.inclination),
                    ))
                .toList()));
  }
}
