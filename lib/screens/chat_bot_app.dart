import 'package:flutter/material.dart';

void main() {
  runApp(ChatbotApp());
}

class ChatbotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent),
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _textController = TextEditingController();

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.add(Message(text: text, isUser: true));
    });

    // Simulate chatbot response
    final chatbotResponse = getChatbotResponse(text);
    _addBotMessage(chatbotResponse);
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(Message(text: text, isUser: false));
    });
  }

  String getChatbotResponse(String userMessage) {
    // Handle different user queries and provide responses here
    userMessage = userMessage.toLowerCase();

    if (userMessage.contains('hello')) {
      return 'Hi there! Welcome to our shopping mall app.';
    } else if (userMessage.contains('how can I shop')) {
      return 'You can start shopping by browsing our wide range of products and adding them to your cart. When you are ready, proceed to checkout.';
    } else if (userMessage.contains('what are the current offers')) {
      return 'We have exciting offers on fashion, electronics, and more. Check out our "Offers" section to see the latest deals.';
    } else if (userMessage.contains('how to contact customer support')) {
      return 'You can reach our customer support team by tapping on the "Contact Us" option in the app menu.';
    } else if (userMessage.contains('store locations')) {
      return 'We have multiple store locations in the city. You can find the nearest store using the "Store Locator" feature in the app.';
    } else {
      return "I'm sorry, I don't have information on that specific topic. Please feel free to ask any other questions.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(
        title: Text('Chat bot'),
      ),
=======
>>>>>>> origin/master
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatMessage(
                  text: message.text,
                  isUser: message.isUser,
                );
              },
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: 'Ask a question',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!isUser)
            CircleAvatar(
              child: Text('Bot'),
            ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color:
                isUser ? Theme.of(context).colorScheme.secondary : Colors.blueGrey,
                borderRadius: isUser
                    ? BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                )
                    : BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> origin/master
