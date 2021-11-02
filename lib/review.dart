library review;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

const maxReviewMark = 5;

class Review {
  final String reviewerName;
  final String reviewContent;
  final int mark;
  final DateTime date;

  Review(
      {required this.reviewerName,
      required this.reviewContent,
      required this.mark,
      required this.date})
      : assert(mark >= 0 && mark <= maxReviewMark);
}

class ReviewDisplay extends StatelessWidget {
  final Review review;

  const ReviewDisplay({required this.review, Key? key}) : super(key: key);

  Widget starMark() {
    return Row(
      children: [
        ...List.generate(review.mark, (index) => const Icon(Icons.star)),
        ...List.generate(maxReviewMark - review.mark,
            (index) => const Icon(Icons.star_border)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat reviewDateFormat = DateFormat.yMMMMd();
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  starMark(),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: Text(review.reviewerName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)))
                ]),
                Text(
                  "On ${reviewDateFormat.format(review.date)}",
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Text(review.reviewContent)
              ],
            )));
  }
}
