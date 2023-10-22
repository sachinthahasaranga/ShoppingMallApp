import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/screens/profile_screen.dart';

import '../providers/location_provider.dart';

class MyAppBar extends StatefulWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  //const MyAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);

    return AppBar(
      elevation: 0.0,
      leading: Container(),
      backgroundColor: Colors.deepPurple,
      title: ElevatedButton(
        onPressed: () {  },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('...', style: TextStyle(color: Colors.deepPurple),),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: IconButton(
            icon: Icon(Icons.account_circle_outlined,), onPressed: () {
            Navigator.pushReplacementNamed(context, ProfileScreen.id);
          },
          ),
        ),
      ],
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.zero,
              filled: true,
              fillColor: Colors.white,

            ),
          ),
        ),
      ),
    );
  }
}