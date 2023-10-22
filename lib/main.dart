import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/auth_provider.dart';
import 'package:shoppingmall/providers/cart_provider.dart';
import 'package:shoppingmall/providers/location_provider.dart';
import 'package:shoppingmall/providers/product_provider.dart';
import 'package:shoppingmall/providers/store_provider.dart';
import 'package:shoppingmall/screens/add_newproduct_screen.dart';
import 'package:shoppingmall/screens/auth_screen.dart';
import 'package:shoppingmall/screens/customer_home.dart';
import 'package:shoppingmall/screens/customer_phone_login.dart';
import 'package:shoppingmall/screens/dashboard_screen.dart';
import 'package:shoppingmall/screens/home_screen.dart';
import 'package:shoppingmall/screens/login_buttons_main.dart';
import 'package:shoppingmall/screens/login_screen.dart';
import 'package:shoppingmall/screens/map_screen.dart';
import 'package:shoppingmall/screens/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shoppingmall/screens/product_list_screen.dart';
import 'package:shoppingmall/screens/profile_screen.dart';
import 'package:shoppingmall/screens/profile_update_screen.dart';
import 'package:shoppingmall/screens/signin_screen.dart';
import 'package:shoppingmall/screens/vendor_home%20_screen.dart';
import 'package:shoppingmall/screens/welcome_screen.dart';
import 'package:shoppingmall/widgets/reset_password_screen.dart';
import 'package:shoppingmall/screens/main_screen.dart';

import 'screens/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_)=>AuthProvider(),),
        Provider(create: (_)=>LocationProvider(),),
        Provider(create: (_)=>ProductProvider()),
      ],
      child: MyApp(),
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>AuthProvider(),),
        ChangeNotifierProvider(create: (_)=>LocationProvider(),),
        ChangeNotifierProvider(create: (_)=>StoreProvider(),),
        ChangeNotifierProvider(create: (_)=>ProductProvider(),),
        ChangeNotifierProvider(create: (_)=>CartProvider(),),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  //const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.deepPurple
        ),
        builder: EasyLoading.init(),
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id:(context)=>SplashScreen(),
          HomeScreen.id:(context)=>HomeScreen(),
          CustomerHomeScreen.id:(context)=>CustomerHomeScreen(),
          WelcomeScreen.id:(context)=>WelcomeScreen(),
          MapScreen.id:(context)=>MapScreen(),
          AuthScreen.id:(context)=>AuthScreen(),
          AddNewProduct.id:(context)=>AddNewProduct(),//my
          SignInScreen.id:(context)=>SignInScreen(),
          ResetPassword.id:(context)=>ResetPassword(),
          //MainScreen.id:(context)=>MainScreen(),
          LoginButtons.id:(context)=>LoginButtons(),
          CustomerMobileLogin.id:(context)=>CustomerMobileLogin(),
          MainScreens.id:(context)=>MainScreens(),
          VendorHomeScreen.id:(context)=>VendorHomeScreen(),

          ProductListScreen.id:(context)=>ProductListScreen(),
          ProfileScreen.id:(context)=>ProfileScreen(),
          UpdateProfile.id:(context)=>UpdateProfile(),

    },
        );
    }
}