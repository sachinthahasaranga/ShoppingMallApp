import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer_v/flutter_slider_drawer_v.dart';
import 'package:shoppingmall/screens/dashboard_screen.dart';
import '../services/drawer_services.dart';
import '../widgets/drawer_menu_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/auth_provider.dart';
import 'package:shoppingmall/providers/location_provider.dart';
import 'package:shoppingmall/screens/signin_screen.dart';
import 'package:shoppingmall/screens/welcome_screen.dart';
import 'package:shoppingmall/widgets/image_slider.dart';
<<<<<<< HEAD
import 'package:shoppingmall/widgets/my_appbar.dart';

=======
import 'package:shoppingmall/widgets/image_slider.dart';
import 'package:shoppingmall/widgets/my_appbar.dart';

class HomeScreen extends StatefulWidget {
  //const HomeScreen({super.key});
  static const String id = 'home-screen';
>>>>>>> origin/master

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

<<<<<<< HEAD
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String id = 'home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override

  DrawerServices _services = DrawerServices();

  GlobalKey<SliderMenuContainerState> _key =
  new GlobalKey<SliderMenuContainerState>();
  String title='';

  Widget build(BuildContext context) {
    //final auth = Provider.of<AuthProvider>(context);
    //final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      body: SliderMenuContainer(
          appBarColor:Colors.white,
          appBarHeight: 80,
          key: _key,
          sliderMenuOpenSize : 250,
          title : Text('', style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700),),
          trailing: Row(
            children: [
              IconButton(
                onPressed: (){},
                icon: Icon(CupertinoIcons.search),
              ),
              IconButton(
                onPressed: (){},
                icon: Icon(CupertinoIcons.bell),
              )
            ],
          ),
          sliderMenu: MenuWidget(
            onItemClick: (title){
              _key.currentState?.closeDrawer();
              setState((){
                this.title = title;
              });
            },
          ),
          sliderMain: _services.drawerScreen(title)),
=======
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(112),
        child: MyAppBar(),
      ),

      body: Center(
          child: Column(
            children: [
              ImageSlider(),
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
>>>>>>> origin/master
    );
  }
}