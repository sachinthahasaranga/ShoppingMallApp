

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices{
  CollectionReference category = FirebaseFirestore.instance.collection('category');
  CollectionReference products = FirebaseFirestore.instance.collection('products');

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

}





