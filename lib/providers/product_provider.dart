import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier{
  String selectedCategory = 'not selected';
  String selectedSubCategory = 'not selected';
  String? categoryImage = '';
  File? image;
  String pickerError = '';
  String shopName= ''; //we need to bring shop name here

  selectCategory(mainCategory,categoryImage){
    this.selectedCategory = mainCategory;
    this.categoryImage =categoryImage; //need to bring image here
    notifyListeners();
  }

  selectSubCategory(selected){
    this.selectedSubCategory = selected;
    notifyListeners();
  }

  getShopName(shopName){
    this.shopName = shopName;
    notifyListeners();
  }

  //upload product image
  Future<String> uploadProductImage(filePath,productName) async{
    File file = File(filePath);
    var timeStamp = Timestamp.now().microsecondsSinceEpoch;

    FirebaseStorage _storage = FirebaseStorage.instance;

    try{
      await _storage.ref('productImage/${this.shopName}$productName$timeStamp').putFile(file);
    }on FirebaseException catch (e){
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('productImage/${this.shopName}$productName$timeStamp').getDownloadURL();
    return downloadURL;
  }


  Future<File?> getProductImage() async {

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 20); // Use pickImage instead of getImage

    if (pickedFile != null) {
      this.image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickerError='Image not Selected';
      print('Image not selected.');
      notifyListeners();
    }
    return this.image;
  }

  alertDialog({context, title, content}){
    showCupertinoDialog(context: context, builder: (BuildContext context){
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(child: Text('OK')),
        ],
      );
    });
  }

  //save product data to firestore
  Future<void>saveProductDataToDb(
      //need to bring these from add product screen
          {
        productName,
        description,
        price,
        comparedPrice,
        collection,
        brand,
        sku,
        weight,
        tax,
        stockQty,
        lowStockQty,
        context,
      }
  )async {
    var timeStamp = DateTime.now().microsecondsSinceEpoch; //this will use as product id
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference _products = FirebaseFirestore.instance.collection('products');
    try{
      _products.doc(timeStamp.toString()).set({
        'seller' : {'shopName' : this.shopName,'sellerUid' : user!.uid},
        'productName' : productName,
        'description' : description,
        'price' : price,
        'comparedPrice' : comparedPrice,
        'collection' : collection,
        'brand' : brand,
        'sku' : sku,
        'category' : {
          'mainCategory' : this.selectedCategory,
          //'subCategory' : this.selectedSubCategory,
          'categoryImage' : this.categoryImage
        },
        'weight' : weight,
        'tax' : tax,
        'stockQty': stockQty,
        'lowStockQty' : lowStockQty,
        'published' : false,  //keep the initial value as false
        'productId' : timeStamp,
      });
      this.alertDialog(
        context: context,
        title: 'SAVE DATA',
        content: 'Product Details saved successfully',
      );

    } catch(e){
      this.alertDialog(
          context: context,
          title: 'SAVE DATA',
          content: '${e.toString()},
      );

    }
    return null;

  }

}