import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteReviewDialog extends StatelessWidget {
  final String userId;
  final int reviewId;
  const DeleteReviewDialog(
      {required this.userId, required this.reviewId, super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    return AlertDialog.adaptive(
      elevation: 0,
      title: Text(i18n.delete_review_title_dialog),
      content: Text(i18n.delete_review_content_dialog),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(i18n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(i18n.delete),
        ),
      ],
    );
  }
}
