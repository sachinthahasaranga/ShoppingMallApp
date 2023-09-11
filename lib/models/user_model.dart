

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const NUMBER = 'number';
  static const ID = 'id';

  String? _number;
  String? _id;

  // Getter
  String? get number => _number;
  String? get id => _id;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    // Check if data is not null and contains the fields
    if (data != null) {
      _number = data[NUMBER] as String?;
      _id = data[ID] as String?;
    } else {
      // Handle the case where data is null
      // You can set default values or throw an exception if needed
      _number = null;
      _id = null;
    }
  }
}