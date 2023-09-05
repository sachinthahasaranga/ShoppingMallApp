import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocery_app/screens/onboard_screen.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(
      Duration(
        seconds: 3,
      ),(){
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context)=>OnBoardScreen(),
        ));
    }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('images/logo.png'),
              Text('Shopping Mall',style: TextStyle(fontSize: 15),)
            ],
            )
      ),
    );
  }
}
