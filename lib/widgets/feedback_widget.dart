import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmall/screens/feedback_display.dart';
import 'package:shoppingmall/screens/profile_screen.dart';

void main() {
  runApp(FeedbackFormApp());
}

class FeedbackFormApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FeedbackForm(),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  // Define variables to store user feedback
  int starRating = 0;
  String innovativeIdeas = '';

  // Create a GlobalKey to identify the Form widget and reset it if needed
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text('User Review' , style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios) , color: Colors.white, onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(),
            ),
          );
        },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question 1 - Five-star rating
              Text('1. Rate our app (5 stars):'),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < starRating ? Icons.star : Icons.star_border,
                      size: 40.0,
                      color: Colors.orange, // Customize the star color
                    ),
                    onPressed: () {
                      setState(() {
                        starRating = index + 1;
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 16.0),

              // Question 2 - Text input
              TextFormField(
                decoration: InputDecoration(
                  labelText: '2. Your Feedback ',
                  hintText: 'Enter your Feedback',
                ),
                onChanged: (value) {
                  setState(() {
                    innovativeIdeas = value;
                  });
                },
                maxLines: 3, // You can adjust the number of lines as needed
              ),
              SizedBox(height: 16.0),

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Create a Firestore instance
                      final firestore = FirebaseFirestore.instance;

                      // Define a map to store the user's feedback data
                      final userData = {
                        'starRating': starRating,
                        'innovativeIdeas': innovativeIdeas,
                        // Add more fields for other questions
                      };

                      try {
                        // Add the data to Firestore
                        await firestore.collection('feedback').add(userData);

                        // Optionally, you can reset the form
                        _formKey.currentState!.reset();

                        // Show a success message using a SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green, // Background color
                            elevation: 6.0, // Shadow elevation
                            behavior: SnackBarBehavior.floating, // Floating design
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0), // Rounded corners
                            ),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.white, // Icon color
                                  size: 24.0, // Icon size
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  'Feedback submitted successfully!',
                                  style: TextStyle(
                                    color: Colors.white, // Text color
                                    fontSize: 16.0, // Text size
                                  ),
                                ),
                              ],
                            ),
                            duration: Duration(seconds: 2), // You can adjust the duration as needed
                          ),
                        );

                        // Navigate to the FeedbackDisplayScreen and pass the entered data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeedbackDisplayScreen(userData: userData),
                          ),
                        );

                      } catch (e) {
                        // Handle any potential errors here
                        print('Error submitting feedback: $e');
                      }
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

