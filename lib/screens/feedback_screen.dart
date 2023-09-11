import 'package:flutter/material.dart';

import '../widgets/feedback_widget.dart';



class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FeedbackFormApp(),
      ),
    );
  }
}
