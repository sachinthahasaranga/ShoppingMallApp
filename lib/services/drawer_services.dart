

import 'package:flutter/cupertino.dart';
import 'package:shoppingmall/screens/banner_screen.dart';
import 'package:shoppingmall/screens/dashboard_screen.dart';
import 'package:shoppingmall/screens/logout_screen.dart';
import 'package:shoppingmall/screens/product_screen.dart';

class DrawerServices{

  Widget drawerScreen(title){
    if(title == 'Dashboard'){
      return MainScreen();
    }

    if(title == 'Product'){
      return ProductScreen();
    }

    if(title == 'Banner'){
      return BannerScreen();
    }

    if(title == 'LogOut'){
      return logoutTempory();
    }
    return MainScreen();


  }

}