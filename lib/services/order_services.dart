
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderServices {
  CollectionReference order = FirebaseFirestore.instance.collection('orders');



  Future<DocumentReference>saveOrder(Map<String,dynamic>data){
    var result = order.add(
        data
    );
    return result;
  }
}