


import 'package:flutter/cupertino.dart';

class ProductProvider with ChangeNotifier{
  String selectedCategory = 'not selected';
  String selectedSubCategory = 'not selected';

  selectCategory(selected){
    this.selectedCategory = selected;
    notifyListeners();
  }

  selectSubCategory(selected){
    this.selectedSubCategory = selected;
    notifyListeners();
  }


}