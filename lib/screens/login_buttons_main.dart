import 'package:flutter/material.dart';

import 'package:shoppingmall/screens/signin_screen.dart';

import 'customer_phone_login.dart';

class LoginButtons extends StatefulWidget {
  //const LoginButtons({super.key});

  static const String id = 'loginbutton-screen';
  @override
  _LoginButtonsState createState() => _LoginButtonsState();
}

class _LoginButtonsState extends State<LoginButtons> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, SignInScreen.id);
              },
              child: Text('Vendor Login'),
            ),
            SizedBox(height: 16), // Adding some spacing between the buttons
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, CustomerMobileLogin.id);
              },
              child: Text('Customer Login'),
            ),
          ],
        ),
      ),
    );
  }
}