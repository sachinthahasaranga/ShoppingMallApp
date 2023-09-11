import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  //const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Hero(
                  tag: 'logo',
                  child: Image.asset('assets/images/LOGO15.png')),
              TextField(),
              TextField(),
              TextField(),
              TextField(),
            ],
          ),
        ),
      ),
    );
  }
}


