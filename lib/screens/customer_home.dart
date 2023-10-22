import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/auth_provider.dart';
import 'package:shoppingmall/providers/location_provider.dart';
import 'package:shoppingmall/widgets/near_by_store.dart';
import 'package:shoppingmall/widgets/top_pick_store.dart';
import 'package:shoppingmall/widgets/image_slider.dart';
import 'package:shoppingmall/widgets/my_appbar.dart';

import 'chat_bot_app.dart';

class CustomerHomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(112),
        child: MyAppBar(),
      ),

      body: ListView(
        children: [
          ImageSlider(),
          Container(
            color: Colors.white,
            height: 200,
            child: TopPickStore(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: NearByStores(),
          ),
          SizedBox(height: 50),
        ],
      ),

      // Add the FloatingActionButton to navigate to the ChatbotApp
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the ChatbotApp when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatbotApp(),
            ),
          );
        },
        child: Icon(Icons.chat_bubble),
        backgroundColor: Colors.deepPurple, // Customize the button's color
      ),
    );
  }
}

void main() {
  runApp(ChatbotApp());
}

class ChatbotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purpleAccent,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.purple), // Set your accent color
      ),
      home: ChatScreen(),
    );
  }
}
