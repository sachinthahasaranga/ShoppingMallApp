import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shoppingmall/screens/customer_home.dart';
import 'package:shoppingmall/screens/favourite_screen.dart';
import 'package:shoppingmall/screens/home_screen.dart';
import 'package:shoppingmall/screens/my_orders_screen.dart';
import 'package:shoppingmall/screens/profile_screen.dart';
import 'package:shoppingmall/screens/welcome_screen.dart';
import 'package:shoppingmall/widgets/cart/cart_notification.dart';

class MainScreens extends StatelessWidget {
  //const MainScreens({super.key});

  static const String id = 'main-screen';

  @override
  Widget build(BuildContext context) {

    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: 0);


    List<Widget> _buildScreens() {
      return [
        //HomeScreen(),
        CustomerHomeScreen(),
        MyOrders(),
        ProfileScreen(),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Container(
            width: 32, // Set the desired width
            height: 32, // Set the desired height
            child: Image.asset('assets/images/sv12.png'),
          ),
          title: "Home",
          activeColorPrimary: CupertinoColors.systemPurple,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),

        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.bag),
          title: ("My Orders"),
          activeColorPrimary: CupertinoColors.systemPurple,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.profile_circled),
          title: ("My Account"),
          activeColorPrimary: CupertinoColors.systemPurple,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      ];
    }

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 56),
        child: CartNotification(shopName: '',),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: PersistentTabView(
        context,
        navBarHeight: 56,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(0.0),
            colorBehindNavBar: Colors.white,
            border: Border.all(
                color: Colors.black45
            )
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style9, // Choose the nav bar style with this property.
      ),
    );
  }
}