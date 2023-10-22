import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/auth_provider.dart';
import 'package:shoppingmall/screens/customer_home.dart';
import 'package:shoppingmall/screens/feedback_screen.dart';
import 'package:shoppingmall/screens/home_screen.dart';
import 'package:shoppingmall/screens/login_buttons_main.dart';
import 'package:shoppingmall/screens/profile_update_screen.dart';
import 'package:shoppingmall/screens/welcome_screen.dart';

import '../widgets/feedback_widget.dart';
import 'feedback_display.dart';
import 'my_orders_screen.dart';

class ProfileScreen extends StatelessWidget {

  const ProfileScreen({super.key});

  static const String id = 'profile-screen';

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<AuthProvider>(context);
    User? user = FirebaseAuth.instance.currentUser;
    userDetails.getUserDetails();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text('grocery store' , style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios) , color: Colors.white, onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerHomeScreen(),
            ),
          );
        },
        ),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('my account' , style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
            Stack(
              children: [
                Container(
                  color: Colors.redAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 39,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text('a' , style: TextStyle(fontSize: 49 , color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 9 ,),
                            Container(
                              height: 60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    userDetails.snapshot != null
                                        ? '${(userDetails.snapshot.data() as Map<String, dynamic>?)?['firstName'] ?? ''} ${(userDetails.snapshot.data() as Map<String, dynamic>?)?['lastName'] ?? ''}'
                                        : 'update your name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if(userDetails.snapshot != null)
                                    Text(
                                        userDetails.snapshot != null ?
                                        '${(userDetails.snapshot.data() as  Map<String , dynamic>)['email'] ?? ''}'  : 'update your email',
                                        style: TextStyle(fontSize: 13 , color: Colors.white)),
                                  Text(user!.phoneNumber ?? 'No Phone Number')

                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 9,),

                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 9.0,
                  child: IconButton(icon: Icon(Icons.edit_outlined , color: Colors.white,),
                    onPressed: () {
                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: UpdateProfile.id),
                        screen: UpdateProfile(),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                    },

                  ),
                )
              ],
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MyOrders(), // Replace MyOrders with your actual screen widget
                  ),
                );
              },
              leading: Icon(Icons.history),
              title: Text('My Order'),
              horizontalTitleGap: 4,
            ),

            Divider(),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FeedbackFormApp()
                  ),
                );
              },
              leading: Icon(Icons.comment_outlined),
              title: Text('My rating'),
              horizontalTitleGap: 4,
            ),


            Divider(),
            ListTile(
              leading: Icon(Icons.notifications_none) , title: Text('notification' , ),horizontalTitleGap: 4 ,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.power_settings_new) , title: Text('Log Out' , ),horizontalTitleGap: 4 ,
              onTap: (){
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginButtons(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

