


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier{
  String selectedCategory = 'not selected';
  String selectedSubCategory = 'not selected';
  File? image;
  String pickerError = " ";

  selectCategory(selected){
    this.selectedCategory = selected;
    notifyListeners();
  }

  selectSubCategory(selected){
    this.selectedSubCategory = selected;
    notifyListeners();
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


}