import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shoppingmall/services/store_service.dart';
import 'package:shoppingmall/services/user_services.dart';

class StoreProvider with ChangeNotifier{
  StoreServices _storeServices = StoreServices();
  UserServices _userServices = UserServices();
  User? user = FirebaseAuth.instance.currentUser;
  var userLatitude = 0.0;
  var userLongitude = 0.0;
  late String selectedStore;
  late String selectedStoreId;
  late DocumentSnapshot storedetails;
  late String selectedProductCategory;

  getSelectedStore(storeDetails){
    this.storedetails = storeDetails;
    notifyListeners();
  }

  selectedCategory(category){
    this.selectedProductCategory = category;
    notifyListeners();
  }
}