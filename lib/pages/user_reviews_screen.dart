import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vims/dialogs/delete_bookmark_dialog.dart';
import 'package:vims/dialogs/delete_review_dialog.dart';
import 'package:vims/providers/implementation/movie_provider.dart';
import 'package:vims/providers/implementation/reviews_provider.dart';
import 'package:vims/widgets/review_item.dart';

class UserReviewsScreen extends StatelessWidget {
  const UserReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser!;
    final provider = Provider.of<UserReviewsProvider>(context);
    final reviews = provider.data!;
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Reviews'),
        ),
        body: ListView(
            children: reviews
                .map((review) => InkWell(
                      onLongPress: () => showDialog(
                        context: context,
                        builder: (context) => DeleteReviewDialog(
                            userId: user.uid, reviewId: review.id),
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
