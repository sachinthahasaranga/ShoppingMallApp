
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/screens/product_screen.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/banner_home_card.dart';
import 'banner_screen.dart';


// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//
//
//   User? user =FirebaseAuth.instance.currentUser;
//   var vendorData;
//
//   @override
//   void initState() {
//     getVendorData();
//     super.initState();
//   }
//
//   Future<DocumentSnapshot>getVendorData()async{
//
//     var result = await FirebaseFirestore.instance.collection('vendors').doc(user!.uid).get();
//     setState(() {
//       vendorData = result;
//     });
//
//     return result;
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthProvider>(context);
//
//     var _provider= Provider.of<ProductProvider>(context);
//     _provider.getShopName(vendorData!=null ?vendorData.data()['shopName']: '');
//
//     return Scaffold(
//
//        body:
//
//       ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           Center(child: Text('Welcome back',style: TextStyle(
//               color: Colors.black,fontWeight: FontWeight.bold,
//           fontSize: 20,),
//           )
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 10),
//             child: Center(
//               child: Text(
//                   vendorData!=null ? vendorData.data()['shopName'] : 'Shop Name',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 25,)
//               ),
//             ),
//           ),
//           BannerHomeCard(),
//           Divider(thickness: 3,),
//           SizedBox(height: 20,),
//
//
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center, // Center the buttons horizontally
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(right: 10),
//                 child: Container(
//                   height: 100,
//                   width: 150,// Set the desired height
//                   child: ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(Color(0xFF130336)),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ProductScreen(),
//                         ),
//                       );
//                     },
//                     child: Text('Products'),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10),
//                 child: Container(
//                   height: 100,
//                   width: 150,// Set the desired height
//                   child: ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(Color(0xFF130336)),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => BannerScreen(),
//                         ),
//                       );
//                     },
//                     child: Text('Edit Banner'),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//
//
//
//
//
//         ],
//       ),
//     );
//   }
// }

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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

    var _provider = Provider.of<ProductProvider>(context);
    _provider.getShopName(vendorData != null ? vendorData.data()['shopName'] : '');

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image(
            image: NetworkImage(
              'https://w0.peakpx.com/wallpaper/922/958/HD-wallpaper-simple-abstract-design-black-flat-modern-red-shapes-waves-white.jpg'
            ),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Your content on top of the background
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Center(
                child: Text(
                  'Welcome back',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
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
              BannerHomeCard(),
              Divider(
                thickness: 3,
              ),
              SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // Center the buttons horizontally
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      height: 100,
                      width: 150, // Set the desired height
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Color(0xFF2B2D2A)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductScreen(),
                            ),
                          );
                        },
                        child: Text('Products'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      height: 100,
                      width: 150, // Set the desired height
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Color(0xFF2B2D2A)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BannerScreen(),
                            ),
                          );
                        },
                        child: Text('Edit Banner'),
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




