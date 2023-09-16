import 'package:flutter/material.dart';

class FeedbackDisplayScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  FeedbackDisplayScreen({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Display'),
      ),
      body: ListView.builder(
        itemCount: userData.length,
        itemBuilder: (context, index) {
          final key = userData.keys.toList()[index];
          final value = userData[key];
          return ListTile(
            title: Text(key),
            subtitle: Text(value.toString()),
          );
        },
      ),
    );

  }
}