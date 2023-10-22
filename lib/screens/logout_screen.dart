import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/screens/signin_screen.dart';
import 'package:shoppingmall/screens/welcome_screen.dart';

import '../providers/auth_provider.dart';
import '../providers/location_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/image_slider.dart';



class logoutTempory extends StatefulWidget {
  const logoutTempory({super.key});

  @override
  State<logoutTempory> createState() => _logoutTemporyState();
}

class _logoutTemporyState extends State<logoutTempory> {

  User? user = FirebaseAuth.instance.currentUser;
  var vendorData;

  @override
  void initState() {
    getVendorData();
    super.initState();
  }

  Future<DocumentSnapshot> getVendorData() async {
    var result =
    await FirebaseFirestore.instance.collection('vendors').doc(user!.uid).get();
    setState(() {
      vendorData = result;
    });

    return result;
  }


  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    var _provider = Provider.of<ProductProvider>(context);
    _provider.getShopName(vendorData != null ? vendorData.data()['shopName'] : '');


    return Scaffold(
      body: Stack(
        children: [
          Image(
            image: NetworkImage(
                'https://w0.peakpx.com/wallpaper/922/958/HD-wallpaper-simple-abstract-design-black-flat-modern-red-shapes-waves-white.jpg'
            ),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),


          ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 40,
              ),
              Center(
                child: Text(
                  'Do you want to log out?',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Center(
                  child: Text(
                    vendorData != null ? vendorData.data()['shopName'] : 'Shop Name',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),


              SizedBox(
                height: 210,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // Center the buttons horizontally
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      height: 60,
                      width: 150, // Set the desired height
                      child: ElevatedButton(
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
                    ),
                  ),

                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

