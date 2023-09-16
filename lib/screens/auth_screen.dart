import 'package:flutter/material.dart';
import 'package:shoppingmall/widgets/image_picker.dart';
import 'package:shoppingmall/widgets/register_form.dart';

class AuthScreen extends StatefulWidget {
  //const AuthScreen({super.key});

  static const String id =  'auth-screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  ShopPicCard(),
                  RegisterForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}