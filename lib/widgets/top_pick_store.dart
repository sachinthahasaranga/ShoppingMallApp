import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/store_provider.dart';
import 'package:shoppingmall/screens/vendor_home%20_screen.dart';
import 'package:shoppingmall/services/store_service.dart';


class TopPickStore extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    StoreServices _storeServices = StoreServices();
    final _storeData = Provider.of<StoreProvider>(context);
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getTopPickedStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapShot) {
          if (!snapShot.hasData) {
            return CircularProgressIndicator();
          }
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                  child: Row(
                    children: [
                      SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset('assets/images/like.gif')),
                      Text('  Suggested For You', style: TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 20),),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapShot.data!.docs.map((
                        DocumentSnapshot document) {
                      return InkWell(
                        onTap: () {
                          _storeData.getSelectedStore(document);
                          PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                            context,
                            settings: RouteSettings(name: VendorHomeScreen.id),
                            screen: VendorHomeScreen(),
                            withNavBar: true,
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Card(
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              4),
                                          child: Image.network(
                                            document['imageUrl'],
                                            fit: BoxFit.cover,))),
                                ),
                                Container(
                                  height: 35,
                                  child: Text(
                                    document['shopName'], style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF261B65),
                                  ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
