import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vims/dialogs/delete_review_dialog.dart';
import 'package:vims/providers/implementation/movie_provider.dart';
import 'package:vims/providers/implementation/reviews_provider.dart';
import 'package:vims/widgets/pull_refresh.dart';
import 'package:vims/widgets/review_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vims/widgets/shimmer/card_movie_shimmer.dart';

class UserReviewsScreen extends StatelessWidget {
  const UserReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    final provider = Provider.of<UserReviewsProvider>(context);

    Widget body;

    if (provider.isLoading && provider.data == null) {
      body = const CardMovieShimmer();
    } else if (!provider.isLoading && provider.data!.isEmpty) {
      body = const _NoReviews();
    } else {
      final reviews = provider.data!
          .map((review) => InkWell(
                onTap: () => context.push('/movie/${review.movieId}'),
                onLongPress: () => showDialog(
                  context: context,
                  builder: (context) => const DeleteReviewDialog(),
                ).then((value) {
                  if (value != null && value) {
                    provider.deleteReview(review);
                    context
                        .read<MovieProvider>()
                        .removeReview(review.movieId, review.id);
                  }
                }),
                child: ReviewItem(
                    content: review.content,
                    author: '',
                    createdAt: review.createdAt,
                    inclination: review.inclination),
              ))
          .toList();

      body = PullRefresh(
        children: reviews,
        onRefresh: () {
          return provider.onRefresh();
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(i18n.title_user_reviews_page),
        ),
        body: RefreshIndicator.adaptive(
            child: body,
            onRefresh: () {
              return provider.onRefresh();
            }));
  }
}

class _NoReviews extends StatelessWidget {
  const _NoReviews();

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;

    return Center(
      child: Text(i18n.no_reviews,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
