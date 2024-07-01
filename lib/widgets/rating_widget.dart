import 'package:meditation_app/localization.dart';
import 'package:meditation_app/providers/comment_provider.dart';
import 'package:meditation_app/providers/rating_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RatingDialog extends ConsumerStatefulWidget {
  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends ConsumerState<RatingDialog> {
  int _rating= 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Localization.of(context)?.translate('rate_session') ?? 'Rate Your Experience'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
           Text(Localization.of(context)?.translate('comment') ?? 'Write your feelings/thoughts during the session'),
          const SizedBox(height: 8),
          TextField(
            onChanged: (text) {
              ref.read(commentNotifierProvider.notifier).setComment(text);
            },
            maxLines: 2,
          ),
          const SizedBox(height: 8),
           Text(Localization.of(context)?.translate('end_rating') ?? 'How would you rate your experience?'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  _rating >= index + 1
                      ? Icons.star
                      : Icons.star_border,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
              );
            },
    
            ),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child:  Text(Localization.of(context)?.translate('cancel') ?? 'Cancel'),
          onPressed: () {
            ref.read(ratingNotifierProvider.notifier).setRating('');
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child:  Text(Localization.of(context)?.translate('submit') ?? 'Submit'),
          onPressed:  _rating != null
              ? () {
                  ref.read(ratingNotifierProvider.notifier).setRating(_rating.toString());
                  // Handle rating submission
                  Navigator.pop(context);
                }
              : () {
                ref.read(ratingNotifierProvider.notifier).setRating('');
                Navigator.pop(context);
              },
        ),
      ],
    );
  }
}