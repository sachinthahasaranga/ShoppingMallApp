import 'package:flutter/material.dart';
import 'package:shoppingmall/screens/home_screen.dart';
import 'package:shoppingmall/widgets/drawer_menu_widget.dart';
import 'package:flutter_slider_drawer_v/flutter_slider_drawer_v.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('dashbord screen'),),
    );
  }
}


