// for all firebase related services for user
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoppingmall/models/user_model.dart';

class UserServices{

  String collection = 'users';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // create new user
  Future<void> createUserData(Map<String, dynamic>values)async{
    String id = values['id'];
    await _firestore.collection(collection).doc(id).set(values);
  }

  // update user data
  Future<void> updateUserData(Map<String, dynamic>values)async{
    String id = values['id'];
    await _firestore.collection(collection).doc(id).update(values);
  }

  // get user data by user id
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return userSnapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

}