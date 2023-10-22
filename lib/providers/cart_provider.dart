import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shoppingmall/services/cart_services.dart';
import 'package:shoppingmall/widgets/cart/cart_card.dart';

class CartProvider with ChangeNotifier {
  CartServices _cart = CartServices();
  double subTotal = 0.0;
  int cartQty = 0;
  late QuerySnapshot snapshot;
  late DocumentSnapshot document;
  List cartList = [];


  Future<double?> getCartTotal() async {
    var cartTotal = 0.0;


    var _newList = [];


    QuerySnapshot snapshot =
    await _cart.cart.doc(_cart.user?.uid).collection('product').get();


    if (snapshot == null) {
      return null;
    }

    snapshot.docs.forEach((doc) {
      // Explicitly cast doc.data() to the expected type (assuming it's a Map<String, dynamic>).
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if(!_newList.contains(doc.data())){
        _newList.add(doc.data());
        this.cartList = _newList;
        notifyListeners();
      }
      // Access properties using []
      cartTotal += data['total'];
    });

    this.subTotal = cartTotal;
    this.cartQty = snapshot.size;
    this.snapshot = snapshot;
    notifyListeners();

    return cartTotal;
  }

  getShopName()async{
    DocumentSnapshot doc = await _cart.cart.doc(_cart.user?.uid).get();
    if(doc.exists){
      this.document = doc;
      notifyListeners();
    }else{
      DocumentSnapshot<Object?>? document = null;
      notifyListeners();
    }
  }


}
