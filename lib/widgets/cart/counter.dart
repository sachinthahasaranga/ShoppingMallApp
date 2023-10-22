import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shoppingmall/services/cart_services.dart';

class CounterForCard extends StatefulWidget {
  final DocumentSnapshot document;
  final Function(int) onQuantityChanged; // Callback to update parent widget

  CounterForCard(this.document, {required this.onQuantityChanged});

  @override
  State<CounterForCard> createState() => _CounterForCardState();
}

class _CounterForCardState extends State<CounterForCard> {
  User? user = FirebaseAuth.instance.currentUser;
  CartServices _cart = CartServices();

  int _qty = 1;
  late String _docId;
  bool _exists = false;
  bool _updating = false;

  Future<void> getCartData() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(user?.uid)
        .collection('product')
        .where('productId', isEqualTo: widget.document['productId'])
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((doc) {
        final dynamic productId = doc['productId']; // Specify the type
        final dynamic qty = doc['qty']; // Specify the type

        if (productId == widget.document['productId']) {
          setState(() {
            _qty = qty ?? 1; // Provide a default value if 'qty' is null
            _docId = doc.id;
            _exists = true;
          });
        }
      });
    } else {
      setState(() {
        _exists = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCartData();
  }

  @override
  Widget build(BuildContext context) {
    return _exists
        ? FutureBuilder(
      future: getCartData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        return Container(
          height: 28,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.pink),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _updating = true;
                  });
                  if (_qty == 1) {
                    _cart.removeFromCart(_docId).then((value) {
                      setState(() {
                        _updating = false;
                        _exists = false;
                      });
                      _cart.checkData();
                    });
                  } else {
                    setState(() {
                      _qty--;
                    });
                    var total = _qty *
                        (widget.document['price'] as double? ?? 0.0); // Specify the type and provide a default value if 'price' is null
                    _cart
                        .updateCartQty(_docId, _qty, total)
                        .then((value) {
                      setState(() {
                        _updating = false;
                      });
                      // Notify the parent widget about the quantity change
                      widget.onQuantityChanged(_qty);
                    });
                  }
                },
                child: Container(
                  child: Icon(
                    _qty == 1
                        ? Icons.delete_outline
                        : Icons.remove,
                    color: Colors.pink,
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                width: 30,
                color: Colors.pink,
                child: Center(
                  child: FittedBox(
                    child: _updating
                        ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(
                            Colors.white),
                      ),
                    )
                        : Text(
                      _qty.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _updating = true;
                    _qty++;
                  });
                  var total = _qty *
                      (widget.document['price'] as double? ?? 0.0); // Specify the type and provide a default value if 'price' is null
                  _cart
                      .updateCartQty(_docId, _qty, total)
                      .then((value) {
                    setState(() {
                      _updating = false;
                    });
                    // Notify the parent widget about the quantity change
                    widget.onQuantityChanged(_qty);
                  });
                },
                child: Center(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Icon(Icons.add, color: Colors.pink)),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    )
        : FutureBuilder(
      future: getCartData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        return InkWell(
          onTap: () {
            EasyLoading.show(status: 'Adding to cart');

            _cart.checkSeller().then((shopname) {
              final dynamic sellerShopName = widget.document['seller']['shopName']; // Specify the type
              print(sellerShopName);

              if (shopname == sellerShopName) {
                setState(() {
                  _exists = true;
                });
                _cart.addToCart(widget.document).then((value) {
                  EasyLoading.showSuccess('Added to cart');
                });
                return;
              }
              if (shopname == null) {
                setState(() {
                  _exists = true;
                });
                _cart.addToCart(widget.document).then((value) {
                  EasyLoading.showSuccess('Added to cart');
                });
                return;
              } else {
                EasyLoading.dismiss();
                showDialog(shopname);
                return;
              }
            });
          },
          child: Container(
            height: 28,
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Text(
                  'Add to wish list',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showDialog(shopName) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Replace cart item'),
          content: Text(
            'Your cart contains items from $shopName. Do you want to discard the selection and add items from ${widget.document['seller']['shopName']}?',
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                'No',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text('Yes'),
              onPressed: () {
                _cart.deleteCart().then((value) {
                  _cart.addToCart(widget.document).then((value) {
                    setState(() {
                      _exists = true;
                    });
                    Navigator.pop(context);
                  });
                });
              },
            ),
          ],
        );
      },
    );
  }
}
