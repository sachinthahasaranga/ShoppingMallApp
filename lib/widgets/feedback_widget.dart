import 'package:flutter/material.dart';

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

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, you can submit the data here
                    // For example, you can print the values to the console
                    print('Personal Shopping Assistant: $personalShoppingAssistant');
                    print('Most Exciting Item: $mostExcitingItem');
                    print('Shopping Speed: $shoppingSpeed');
                    // Add more print statements for other questions

                    // Optionally, you can reset the form
                    _formKey.currentState!.reset();
                  }
                },
                child: Text('Submit'),
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
