import 'package:flutter_test/flutter_test.dart';

import 'package:review/review.dart';

void main() {
  test('Review toString', () {
    final review = Review(
        reviewerName: "Bob",
        reviewContent: "My review",
        mark: 3,
        date: DateTime(2000));
    expect(
        review.toString(),
        equals(
            "Review of 3 out of 5 by Bob on 2000-01-01 00:00:00.000 : My review"));
  });
}
