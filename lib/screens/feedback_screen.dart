import 'package:flutter/material.dart';
import '../widgets/feedback_widget.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

<<<<<<< HEAD
=======
import '../widgets/feedback_widget.dart';
import 'package:meta/meta.dart';

import 'package:flutter/material.dart';

>>>>>>> origin/master
class FeedbackScreen extends StatelessWidget {
  final Key key;

  const FeedbackScreen({required this.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
<<<<<<< HEAD
          body: FeedbackFormApp()
=======
        body: FeedbackFormApp()
>>>>>>> origin/master
      ),
    );
  }
}