import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/screens/signin_screen.dart';
import 'package:shoppingmall/screens/welcome_screen.dart';

import '../providers/auth_provider.dart';
import '../providers/location_provider.dart';
import '../widgets/image_slider.dart';


class logoutTempory extends StatefulWidget {
  const logoutTempory({super.key});

  @override
  State<logoutTempory> createState() => _logoutTemporyState();
}

class _logoutTemporyState extends State<logoutTempory> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(

      body: Center(
          child: Column(
            children: [
              //ImageSlider(),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF130336)),
                ),
                onPressed: () {
                  auth.error='';

                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>SignInScreen(),
                    ));
                  });
                },
                child: Text('Sign Out'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF130336)),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, WelcomeScreen.id);
                },
                child: Text('Home Screen'),
              ),
            ],
          )
      ),
    );
  }
}
