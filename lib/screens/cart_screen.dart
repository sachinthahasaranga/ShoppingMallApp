
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/screens/profile_screen.dart';
import 'package:shoppingmall/services/cart_services.dart';
import 'package:shoppingmall/services/order_services.dart';
import 'package:shoppingmall/services/store_service.dart';
import 'package:shoppingmall/services/user_services.dart';
import 'package:shoppingmall/widgets/cart/cart_list.dart';

import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';


class CartScreen extends StatefulWidget {
  static const String id = 'cart-screen';

  Future<QuerySnapshot> getData() async {//
    return await FirebaseFirestore.instance.collection('vendor').get();
  }

  final DocumentSnapshot document;
  CartScreen({required this.document});


  @override
  _CartScreenState createState() => _CartScreenState();
}



class _CartScreenState extends State<CartScreen> {

  StoreServices _store = StoreServices();
  UserServices _userServices = UserServices();
  OrderServices _orderServices = OrderServices();
  CartServices _cartServices = CartServices();
  User? user = FirebaseAuth.instance.currentUser;
  late DocumentSnapshot doc;
  var textStyle = TextStyle(color: Colors.grey);


  void _clearCart() {
    EasyLoading.showSuccess('Clearing cart');
    _cartServices.deleteCart().then((value) {
      _cartServices.checkData().then((value) {
        // Cart is cleared, you can update the UI or navigate to another screen
        Navigator.pop(context); // This is just an example. You can navigate or update the UI accordingly.
      });
    });
  }

  int discount = 0;
  int services = 60;
  bool _checkingUser = false;
  @override
  void initState() {
    _store.getShopDetails(widget.document.data()??['sellerUid']).then((value) {
      setState(() {
        doc = value;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var _cartProvider = Provider.of<CartProvider>(context);
    var userDetails = Provider.of<AuthProvider>(context);

    userDetails.getUserDetails();

    var _saving = (_cartProvider.subTotal * 2) / 100;
    var _payable = _cartProvider.subTotal + services - _saving ;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      bottomSheet: Container(
        height: 60,
        color: Colors.blueGrey[600],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20 , right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('\$${_cartProvider.subTotal.toStringAsFixed(0)}' , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
                    Text('(including taxes)' , style: TextStyle(color: Colors.green , fontSize: 9),)
                  ],
                ),


                ElevatedButton(
                  onPressed: () {
                    _clearCart();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.delete_forever_rounded, // Replace with your desired icon
                        color: Colors.white,
                      ),
                      SizedBox(width: 2), // Adjust the spacing between the icon and text
                    ],
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    EasyLoading.show(status: 'please wait');
                    _userServices.getUserById(user!.uid).then((value){
                      if (value != null && value['userName'] == null) {
                        _saveOrder(_cartProvider , _payable);
                        EasyLoading.showSuccess('your order is submit');

                      }else{

                      }


                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: _checkingUser ? CircularProgressIndicator() : Text('Added'),
                )

              ],
            ),
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.purple,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        (widget.document?.data() as Map<String, dynamic>?)?['shopName'] ?? '',
                        style: TextStyle(fontSize: 19, color: Colors.black),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Text(
                        '${_cartProvider.cartQty}${_cartProvider.cartQty > 1 ? 'Items' : 'Item'}',
                        style: TextStyle(fontSize: 19, color: Colors.black),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ];
        },
        body: _cartProvider.cartQty > 0 ? SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 90),
          child: Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                Text(
                  (widget.document?.data() as Map<String, dynamic>?)?['shopName'] ?? '',
                  style: TextStyle(fontSize: 19, color: Colors.black , fontWeight: FontWeight.bold),
                ),
                CartList( widget.document),
                //CouponWidget(),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('bill detail' , style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox(height: 10 ,),
                            Row(
                              children: [
                                Expanded(child: Text('Wishlist Price ' , style: textStyle,)),
                                Text('\$${_cartProvider.subTotal.toStringAsFixed(0)}' , style: textStyle,),
                                SizedBox(height: 10,),

                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(child: Text('discount ' , style: textStyle,)),
                                Text('\$${_saving.toStringAsFixed(0)}' , style: textStyle,),
                                SizedBox(height: 10,),

                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(child: Text('Service Charge' , style: textStyle,)),
                                Text('\$$services' , style: textStyle,),

                              ],
                            ),
                            Divider(color: Colors.grey,),
                            Row(
                              children: [
                                Expanded(child: Text('Total Amount' , style: TextStyle(fontWeight: FontWeight.bold),)),
                                Text('\$${_payable.toStringAsFixed(0)}' , style: TextStyle(fontWeight: FontWeight.bold),),

                              ],
                            ),
                            SizedBox(height: 10,),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(context).primaryColor.withOpacity(.4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('total saving' , style: TextStyle(color: Colors.green),)),
                                    Text('\$${_saving.toStringAsFixed(0)}' , style: TextStyle(color: Colors.green),),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                    ),
                  ),
                ),

              ],

            ),
          ),
        ):Center(child: Text('cart empty , continue shopping'),),


      ),
    );
  }

  _saveOrder(CartProvider cartProvider , payable){
    _orderServices.saveOrder({
      'products' : cartProvider.cartList,
      'userId' : user?.uid,
      'total' : payable,
      'discont' : discount,
      //'discountCode' : coupon.document == null ? null : coupon.document.data()['title'],
      'selle': {
        'shopName' : widget.document.data()??['shopName'],
        'sellerId' : widget.document.data()??['sellerUid'],
      },
      'timestamp' : DateTime.now().toString(),
      'orderStatus' : 'Added'


    }).then((value){
      _cartServices.deleteCart().then((value){
        _cartServices.checkData().then((value){
          Navigator.pop(context);
        });
      });
    });
  }
}


