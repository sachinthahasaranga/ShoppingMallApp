import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmall/screens/signin_screen.dart';

import 'home_screen.dart';
import 'welcome_screen.dart';


class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //const SplashScreen({super.key});

  @override
  void initState() {
    Timer(
        Duration(
            seconds: 3), ()
    {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if(user==null){
          Navigator.pushReplacementNamed(context, SignInScreen.id);
        }else{
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
      } );
    }
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
            tag: 'logo',

            child: Image.asset('assets/images/LOGO11.png')),
      ),
    );
  }
}