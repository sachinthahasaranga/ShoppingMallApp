
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


import '../../services/cart_services.dart';


class AddWishlistWidget extends StatefulWidget {
  final DocumentSnapshot document;

  AddWishlistWidget(this.document);

  @override
  State<AddWishlistWidget> createState() => _AddWishlistWidgetState();
}

class _AddWishlistWidgetState extends State<AddWishlistWidget> {
  CartServices _cart = CartServices();
  User user = FirebaseAuth.instance.currentUser!;

  bool _loading = true;
  bool _exists = false;
  int _qty = 1;

  late String _docId;

  @override
  void initState() {
    getCartData();
    super.initState();
  }

  getCartData() async {
    final snapshot =
    await _cart.cart.doc(user.uid).collection('products').get();
    if (snapshot.docs.length == 0) {
      setState(() {
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.document != null) {
      FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('product')
          .where('productId', isEqualTo: widget.document['productId'])
          .get()
          .then((QuerySnapshot querySnapshot) => {
        querySnapshot.docs.forEach((doc) {
          if (doc['productId'] == widget.document['productId']) {
            setState(() {
              _exists = true;
              _qty = doc['qty'];
              _docId = doc.id;
            });
          }
        }),
      });
    }

    return _loading
        ? Container(
      height: 56,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor),
      ),
    )
        //: _exists
        //? CounterWidget(widget.document , _qty , _docId)
        : InkWell(
      onTap: () {
        EasyLoading.show(status: 'Adding to cart');
        _cart.addToCart(widget.document).then((value) {
          setState(() {
            _exists = true;
          });
          EasyLoading.showSuccess('Added to cart');
        });

        if (widget.document != null && widget.document.exists) {
          Map<String, dynamic> productData = {
            'productId': widget.document['productId'],
            'productName': widget.document['productName'],
            'weight': widget.document['weight'],
            'price': widget.document['price'],
            'comparedPrice': widget.document['comparedPrice'],
            'sku': widget.document['sku'],
          };

          _cart.addToCart(productData).then((value) {
            EasyLoading.showSuccess('Added to cart');
          }).catchError((error) {
            EasyLoading.showError('Error adding to cart: ');
          });
       } else {
          EasyLoading.showError('Error: Product data not available');
        }
      },
      child: Container(
        height: 56,
        color: Colors.red[400],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.shopping_basket_outlined),
                SizedBox(width: 9),
                Text(
                  'Add to wishlist',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
