import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/screens/home_screen.dart';
import 'package:shoppingmall/screens/signin_screen.dart';
import 'package:shoppingmall/screens/welcome_screen.dart';
import 'package:shoppingmall/widgets/drawer_menu_widget.dart';
import 'package:flutter_slider_drawer_v/flutter_slider_drawer_v.dart';

import '../providers/auth_provider.dart';
import '../services/firebase_services.dart';
import '../widgets/banner_card.dart';
import '../widgets/banner_home_card.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  FirebaseServices _services = FirebaseServices();
  bool _visible = false;
  File? _image;
  var _imagePathText = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(

       body:
      // Center(
      //     child: Column(
      //       children: [
      //         BannerHomeCard(),
      //         //ImageSlider(),
      //         ElevatedButton(
      //           style: ButtonStyle(
      //             backgroundColor: MaterialStateProperty.all(Color(0xFF130336)),
      //           ),
      //           onPressed: () {
      //             auth.error='';
      //
      //             FirebaseAuth.instance.signOut().then((value) {
      //               Navigator.push(context, MaterialPageRoute(
      //                 builder: (context)=>SignInScreen(),
      //               ));
      //             });
      //           },
      //           child: Text('Sign Out'),
      //         ),
      //         ElevatedButton(
      //           style: ButtonStyle(
      //             backgroundColor: MaterialStateProperty.all(Color(0xFF130336)),
      //           ),
      //           onPressed: () {
      //             Navigator.pushNamed(context, WelcomeScreen.id);
      //           },
      //           child: Text('Home Screen'),
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.only(top: 50),
      //           child: Center(child: Text('Dashbord Screen')),
      //         ),
      //       ],
      //     )
      // ),
      ListView(
        padding: EdgeInsets.zero,
        children: [
          BannerHomeCard(),
          Divider(thickness: 3,),
          SizedBox(height: 20,),




        ],
      ),
    );
  }
}




