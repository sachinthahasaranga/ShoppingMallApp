import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmall/screens/feedback_display.dart';

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
  String personalShoppingAssistant = 'Excellent';
  String mostExcitingItem = '';
  double shoppingSpeed = 5.0;
  String virtualShopping = '';
  String wishlistUsage = 'Never';
  bool paymentIssues = false;
  String memorableShoppingAdventure = '';
  String appPersonality = '';
  String innovativeIdeas = '';
  String seasonalShopping = '';
  String reviewImportance = '';
  String timeTravelShopping = '';
  String appMotivation = '';
  String fashionAdvice = '';
  String appRename = '';
  String shoppingSoundtrack = '';
  String travelShopping = '';

  // Create a GlobalKey to identify the Form widget and reset it if needed
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Form'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question 1
              Text('1. Personal Shopping Assistant:'),
              buildRadioGroup(
                options: ['Excellent', 'Average', 'Needs Improvement'],
                selectedValue: personalShoppingAssistant,
                onChanged: (value) {
                  setState(() {
                    personalShoppingAssistant = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),

              // Question 2
              Text('2. Product Discovery:'),
              buildRadioGroup(
                options: ['A new fashion trend', 'A great deal or discount', 'None, I stick to my usual purchases'],
                selectedValue: mostExcitingItem,
                onChanged: (value) {
                  setState(() {
                    mostExcitingItem = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),

              // Question 3
              Text('3. Shopping Speed:'),
              Slider(
                value: shoppingSpeed,
                onChanged: (value) {
                  setState(() {
                    shoppingSpeed = value;
                  });
                },
                min: 1.0,
                max: 10.0,
                divisions: 9,
                label: shoppingSpeed.toString(),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "4. Innovative Ideas For Improve App *", // Add an asterisk to indicate required
                  hintText: "Enter your innovative ideas here",
                ),
                onChanged: (value) {
                  setState(() {
                    innovativeIdeas = value;
                  });
                },
                maxLines: 3, // You can adjust the number of lines as needed
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is required.';
                  }
                  return null; // Return null to indicate that the field is valid
                },
              ),
              SizedBox(height: 16.0),

              // Add more questions in a similar format

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Create a Firestore instance
                      final firestore = FirebaseFirestore.instance;

                      // Define a map to store the user's feedback data
                      final userData = {
                        'personal Shopping Assistant': personalShoppingAssistant,
                        'most Exciting Item': mostExcitingItem,
                        'shopping Speed': shoppingSpeed,
                        'innovative Ideas': innovativeIdeas,
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

  // Helper function to build a radio button group
  Widget buildRadioGroup({
    required List<String> options,
    required String selectedValue,
    void Function(String?)? onChanged,
  }) {
    return Column(
      children: options.map((option) {
        return Row(
          children: [
            Radio<String>(
              value: option,
              groupValue: selectedValue,
              onChanged: onChanged,
            ),
            Text(option),
          ],
        );
      }).toList(),
    );
  }
}

Future<List<Map<String, dynamic>>> fetchFeedbackData() async {
  final firestore = FirebaseFirestore.instance;
  final querySnapshot = await firestore.collection('feedback').get();

  return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
}