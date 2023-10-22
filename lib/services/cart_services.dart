
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CartServices {
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> addToCart(document) async {
    Map<String, dynamic> documentData = document.data() as Map<String, dynamic>;

    await cart.doc(user!.uid).set({
      'user': user!.uid,
      'sellerUid': documentData['seller']['sellerUid'],
      'shopName': documentData['seller']['shopName'],
    });

    await cart.doc(user!.uid).collection('product').add({
      'productId': documentData['productId'],
      'productName': documentData['productName'],
      'productImage': documentData['productImage'],
      'weight': documentData['weight'],
      'price': documentData['price'],
      'comparedPrice': documentData['comparedPrice'],
      'sku': documentData['sku'],
      'qty': 1,
      'total' : document.data()['price'],
    });
  }

  Future<void> updateCartQty(docId, qty , total) async {
    // Create a reference to the document the transaction will use
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('product')
        .doc(docId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("Product does not exist in cart");
      }

      // Perform an update on the document
      transaction.update(documentReference, {'qty': qty , 'total' : total,});

      // Return the new count
      return qty;
    }).then((value) => print("Updated the cart: $value")).catchError(
            (error) => print("Failed to update cart: $error"));
  }

  Future<void> removeFromCart(docId) async {
    await cart.doc(user!.uid).collection('product').doc(docId).delete();
  }

  Future<void> checkData() async {
    final snapshot = await cart.doc(user!.uid).collection('product').get();
    if (snapshot.docs.length == 0) {
      await cart.doc(user!.uid).delete();
    }
  }

  Future<void> deleteCart() async {
    final result = await cart.doc(user!.uid).collection('product').get();
    for (DocumentSnapshot ds in result.docs) {
      ds.reference.delete();
    }
  }

  Future<String?> checkSeller() async {
    final snapshot = await cart.doc(user!.uid).get();
    final data = snapshot.data() as Map<String, dynamic>?;

    return data != null ? data['shopName'] : null;
  }


  Future<DocumentSnapshot>getShopName()async{
    DocumentSnapshot doc = await cart.doc(user?.uid).get();
    return doc;
  }

}
