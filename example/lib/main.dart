import 'package:flutter/material.dart';
import 'package:review/review.dart';

final List<Review> exampleReviews = [
  Review(
      reviewerName: "Bob",
      reviewContent: "This is great !",
      mark: 4,
      date: DateTime.now()),
  Review(
      reviewerName: "Bob",
      reviewContent:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      mark: 5,
      date: DateTime.now()),
  Review(
      reviewerName: "A veryyyyyyyyy lonnnnnnnnnnnnnnnnnnnnnnng reviewerName",
      reviewContent: "reviewContent",
      mark: 0,
      date: DateTime(2021, 01, 01))
];
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Review> _reviews = exampleReviews;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example usage of Review"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: exampleReviews
                .map((review) => ReviewDisplay(review: review))
                .toList(),
          )),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final review = await showReviewForm(context);
            if (review != null) {
              setState(() {
                _reviews.add(review);
              });
            }
          },
          child: const Icon(Icons.add)),
    );
  }
}
