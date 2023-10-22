import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedbackDisplayScreen extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Key? key;

  FeedbackDisplayScreen({required this.userData, this.key}) : super(key: key);

  void _likeFeedback(String feedbackId) async {
    final firestore = FirebaseFirestore.instance;

    // Increment the 'likes' field in the Firestore document
    await firestore.collection('feedback').doc(feedbackId).update({
      'likes': FieldValue.increment(1),
    });
  }

  void _dislikeFeedback(String feedbackId) async {
    final firestore = FirebaseFirestore.instance;

    // Decrement the 'likes' field in the Firestore document (you can add checks to prevent negative likes)
    await firestore.collection('feedback').doc(feedbackId).update({
      'likes': FieldValue.increment(-1),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Submitted'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('feedback').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final feedbackData = snapshot.data!.docs;

          if (feedbackData.isEmpty) {
            return Center(
              child: Text('No feedback available.'),
            );
          }

          return ListView.builder(
            itemCount: feedbackData.length,
            itemBuilder: (context, index) {
              final feedbackDoc = feedbackData[index];
              final feedbackId = feedbackDoc.id;
              final userData = feedbackDoc.data() as Map<String, dynamic>;

              final starRating = userData['starRating'] ?? 0;
              final innovativeIdeas = userData['innovativeIdeas'] ?? '';
              final likes = userData['likes'] ?? 0;

              return Card(
                elevation: 2.0,
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < starRating ? Icons.star : Icons.star_border,
                            size: 24.0,
                            color: Colors.orange,
                          );
                        }),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Feedback: $innovativeIdeas',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.thumb_up),
                            onPressed: () {
                              _likeFeedback(feedbackId);
                            },
                          ),
                          Text('$likes'), // Display the number of likes
                          IconButton(
                            icon: Icon(Icons.thumb_down),
                            onPressed: () {
                              _dislikeFeedback(feedbackId);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
