
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmall/services/cart_services.dart';
import 'package:shoppingmall/widgets/cart/cart_card.dart';

class CartList extends StatefulWidget {

  final DocumentSnapshot document;
  CartList(this.document);
  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {

  CartServices _cart = CartServices();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _cart.cart.doc(_cart.user?.uid).collection('product').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }

        return new ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return CartCard(); // Create a CartCard widget for each document
          }).toList(),
        );

      },
    );
  }
}
