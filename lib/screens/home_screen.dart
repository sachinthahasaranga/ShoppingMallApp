import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer_v/flutter_slider_drawer_v.dart';
import 'package:shoppingmall/screens/dashboard_screen.dart';

import '../services/drawer_services.dart';
import '../widgets/drawer_menu_widget.dart';

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
    );
  }
}
