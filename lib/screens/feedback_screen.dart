import 'package:flutter/material.dart';
import '../widgets/feedback_widget.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  final Key key;

  const FeedbackScreen({required this.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: FeedbackFormApp()
      ),
    );
  }
}