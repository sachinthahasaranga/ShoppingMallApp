
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/cart_provider.dart';
import 'package:shoppingmall/screens/cart_screen.dart';
import 'package:shoppingmall/services/cart_services.dart';

class CartNotification extends StatefulWidget {
  final String shopName; // Add a parameter to receive the shop name

  CartNotification({required this.shopName});

  @override
  State<CartNotification> createState() => _CartNotificationState();
}

class _CartNotificationState extends State<CartNotification> {



  CartServices _cart = CartServices();
  late DocumentSnapshot document;
  @override
  Widget build(BuildContext context) {
    final _cartProvider = Provider.of<CartProvider>(context);
    _cartProvider.getCartTotal();
    _cart.getShopName().then((value){
      setState(() {
        document = value;
      });
    });
    return Visibility(
      //visible: _cartProvider.cartQty > 1 ? true :false,
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(19) , topLeft: Radius.circular(19),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${_cartProvider.cartQty} | ${_cartProvider.cartQty == 1 ? 'Item' : 'Items'}',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    if(document.exists)
                      Text(
                        '${(document.data() as Map<String, dynamic>)?['shopName']}', // Access the shopName property
                        style: TextStyle(color: Colors.white, fontSize: 9),
                      ),
                    Text(
                      '\$${_cartProvider.subTotal.toStringAsFixed(0)}', // Access the shopName property
                      style: TextStyle(color: Colors.white, fontSize: 9),
                    )

                  ],
                ),
              ),
              InkWell(
                onTap: () {

                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: CartScreen.id),
                    screen: CartScreen(
                      document: document,// Pass the shopName as a parameter
                    ),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );

                },
                child: Container(
                  child: Row(
                    children: [
                      Text(
                        'View cart',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5,),
                      Icon(Icons.shopping_bag_outlined, color: Colors.white,)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
