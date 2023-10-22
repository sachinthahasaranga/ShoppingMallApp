import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
      theme: ThemeData(
        primaryColor: Colors.blue,
        hintColor: Colors.green,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final List<String> messages = [];
  String currentCategory = "";
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Welcome message from the chatbot
    messages.add('App: Welcome to the Shopping Mall Support Chatbot! How can I assist you today?');
  }

  void handleUserInput(String text) {
    setState(() {
      messages.add('User: $text');

      // Implement logic for handling user input creatively
      if (text.toLowerCase().contains('help')) {
        // User asked for help
        messages.add('App: Sure, I can help. What specifically do you need assistance with?');
      } else if (text.toLowerCase().contains('categories')) {
        // User asked for available categories
        messages.add('App: We have two main categories: "Product Information" and "Store Assistance".');
        messages.add('App: Which one are you interested in?');
      } else if (text.toLowerCase().contains('product information')) {
        // User selected "Product Information"
        currentCategory = 'Product Information';
        messages.add('App: Great choice! You are now in the "Product Information" category.');
        messages.add('App: Please ask about any product details you need.');
      } else if (text.toLowerCase().contains('store assistance')) {
        // User selected "Store Assistance"
        currentCategory = 'Store Assistance';
        messages.add('App: Excellent! You are now in the "Store Assistance" category.');
        messages.add('App: How can we assist you with your in-store experience?');
      } else if (currentCategory == 'Product Information') {
        // Handle product-related questions creatively
        // Implement product information lookup logic here
        // Example: "App: The latest smartphones are available in the electronics section."
      } else if (currentCategory == 'Store Assistance') {
        // Handle store assistance creatively
        // Implement store assistance logic here
        // Example: "App: Our store staff will be happy to help you. Please visit the Customer Service desk."
      } else {
        messages.add('App: I didn\'t quite catch that. How may I assist you?');
      }

      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Mall Support'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ChatBubble(
                  text: messages[index],
                  isUserMessage: messages[index].startsWith('User: '),
                );
              },
            ),
          ),
          TextField(
            onSubmitted: (String text) {
              handleUserInput(text);
            },
            decoration: InputDecoration(
              hintText: 'Enter your question...',
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  handleUserInput("User: " + _controller.text);
                },
              ),
            ),
            controller: _controller,
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUserMessage;

  ChatBubble({required this.text, required this.isUserMessage});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.blue : Colors.green,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
    );
  }
}
