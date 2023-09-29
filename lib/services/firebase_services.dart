

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices{

  User? user = FirebaseAuth.instance.currentUser;

  CollectionReference category = FirebaseFirestore.instance.collection('category');
  CollectionReference products = FirebaseFirestore.instance.collection('products');
  CollectionReference vendorbanner = FirebaseFirestore.instance.collection('vendorbanner');

  Future<void>publishProduct({id}){
    return products.doc(id).update({
      'published' : true,
    });
  }

  Future<void>unPublishProduct({id}){
    return products.doc(id).update({
      'published' : false,
    });
  }

  Future<void>deleteProduct({id}){
    return products.doc(id).delete();
  }
//vendorbanner
  Future<void>saveBanner(url){
    return vendorbanner.add({
      'imageUrl' : url,
      'sellerUid' : user!.uid,
    });
  }

  Future<void>deleteBanner({id}){
    return vendorbanner.doc(id).delete();
  }

}





