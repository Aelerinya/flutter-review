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

  @override
  String toString() {
    return "Review of $mark out of $maxReviewMark by $reviewerName on $date : $reviewContent";
  }
}

class ReviewDisplay extends StatelessWidget {
  final Review review;

  const ReviewDisplay({required this.review, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat reviewDateFormat = DateFormat.yMMMMd();
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  StarRating(rating: review.mark),
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

class StarRating extends StatelessWidget {
  final int? rating;
  final Function(int rating)? onClick;
  const StarRating({required this.rating, this.onClick, Key? key})
      : super(key: key);

  Icon _buildStarIcon(int starRate) {
    if (rating == null) {
      return const Icon(Icons.star, color: Colors.grey);
    } else if (starRate <= rating!) {
      return const Icon(Icons.star);
    } else {
      return const Icon(Icons.star_border);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxReviewMark, (index) {
        final starRating = index + 1;
        return IconButton(
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            onPressed: () {
              if (onClick != null) {
                if (rating == starRating) {
                  onClick!(0);
                } else {
                  onClick!(starRating);
                }
              }
            },
            icon: _buildStarIcon(starRating));
      }),
    );
  }
}

class ReviewRateFormField extends FormField<int> {
  ReviewRateFormField(
      {Key? key,
      FormFieldSetter<int>? onSaved,
      FormFieldValidator<int>? validator,
      int? initialValue,
      AutovalidateMode? autovalidateMode,
      String? restorationId})
      : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          restorationId: restorationId,
          builder: (state) {
            return InputDecorator(
                child: StarRating(
                    rating: state.value,
                    onClick: (rating) {
                      state.didChange(rating);
                    }),
                decoration: InputDecoration(
                  errorText: state.errorText,
                  border: InputBorder.none,
                  isCollapsed: true,
                ));
          },
        );
}

class ReviewForm extends StatefulWidget {
  const ReviewForm({Key? key}) : super(key: key);

  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _authorController = TextEditingController();
  final _reviewController = TextEditingController();
  int? _reviewRating;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void onSubmit() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        Navigator.of(context).pop(Review(
            reviewerName: _authorController.text,
            reviewContent: _reviewController.text,
            mark: _reviewRating!,
            date: DateTime.now()));
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Publish a review"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _authorController,
                    onFieldSubmitted: (_data) => onSubmit(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: "Your name"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ReviewRateFormField(
                    onSaved: (value) {
                      setState(() {
                        _reviewRating = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Please select a rating";
                      }
                    },
                  ),
                  TextFormField(
                      controller: _reviewController,
                      onFieldSubmitted: (_data) => onSubmit(),
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(hintText: "Your review")),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: onSubmit, child: const Text("Create review"))
                ],
              ))),
    );
  }

  @override
  void dispose() {
    _authorController.dispose();
    _reviewController.dispose();
    super.dispose();
  }
}

Future<Review?> showReviewForm(BuildContext context) {
  return Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const ReviewForm()));
}
