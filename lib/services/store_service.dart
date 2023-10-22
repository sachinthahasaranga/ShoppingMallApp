import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices{
  CollectionReference vendorbanner = FirebaseFirestore.instance.collection('vendorbanner');
  CollectionReference vendors = FirebaseFirestore.instance.collection('vendors');


  getTopPickedStore(){
    return vendors.where(
        'accVerified', isEqualTo: true).where('isTopPicked', isEqualTo: true).orderBy('shopName').snapshots();
  }

  Future<DocumentSnapshot>getShopDetails(sellerUid)async{
    DocumentSnapshot snapshot = await vendors.doc(sellerUid).get();
    return snapshot;
  }
}