

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/product_provider.dart';
import 'package:shoppingmall/services/firebase_services.dart';

import '../widgets/category_list.dart';


class EditViewProduct extends StatefulWidget {
  //const EditViewProduct({super.key, required this.productId});
  final String productId;
  EditViewProduct({required this.productId});

  @override
  State<EditViewProduct> createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {

  FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();

  List<String> _collections = [
    'Featured products',
    'Best Selling',
    'Recently Added',
  ];
  String? dropdownValue;

  var _brandText = TextEditingController();
  var _skuText = TextEditingController();
  var _productNameText = TextEditingController();
  var _weightText = TextEditingController();
  var _priceText = TextEditingController();
  var _comparedPriceText = TextEditingController();
  var _descriptionText = TextEditingController();
  var _categoryTextController = TextEditingController();
  //var _subCategoryTextController=TextEditingController();
  var _stockTextController = TextEditingController();
  var _lowStockTextController = TextEditingController();
  var _taxTextController = TextEditingController();


  DocumentSnapshot? doc;
  double? discount;
  String? image;
  File? _image;
  bool _visible =false;

  @override
  void initState() {
    getProductDetails();
    super.initState();
  }

  Future<void>getProductDetails()async{
    _services.products.doc(widget.productId).get().then((DocumentSnapshot document) {
      if (document.exists) {
        final data = document.data() as Map<String, dynamic>?;
        //final Price = data?['price'] as String;
        setState(() {
          doc = document;
          _brandText.text = data?['brand'];
          _skuText.text = data?['sku'];
          _productNameText.text = data?['productName'];
          _weightText.text = data?['weight'];
          _priceText.text = data!['price'].toString();
          _comparedPriceText.text = data!['comparedPrice'].toString();
          discount = (double.parse(_priceText.text)/int.parse(_comparedPriceText.text)*100);
          image = data?['productImage'];
          _descriptionText.text = data?['description'];
          _categoryTextController.text = data?['category']['mainCategory'];
          //_subCategoryTextController.text = data?['category']['subCategory'];
          dropdownValue = data?['collection'];
          _stockTextController.text = data!['stockQty'].toString();
          _lowStockTextController.text = data!['lowStockQty'].toString();
          _taxTextController.text = data!['tax'].toString();


        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: doc==null? Center(child: CircularProgressIndicator()): Form(
      //body:  Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 80,
                        height: 30,
                        child: TextFormField(
                          controller: _brandText,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:10,right: 10),
                            hintText: 'Brand',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Theme.of(context).primaryColor.withOpacity(.1),

                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('SKU :  '),
                          Container(
                            width: 50,
                            child: TextFormField(
                              controller: _skuText,
                              style: TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      controller: _productNameText,
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      controller: _weightText,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 80,
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            prefixText: '\$',
                          ),
                          controller: _priceText,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        width: 80,
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            prefixText: '\$',
                          ),
                          controller: _comparedPriceText,
                          style: TextStyle(fontSize: 15,decoration: TextDecoration.lineThrough),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.red,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8,right: 8),
                          child: Text('${discount?.toStringAsFixed(0)}% OFF',style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                  Text('Inclusive of all Taxes', style: TextStyle(color: Colors.grey,
                      fontSize: 12
                  ),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _image!=null? Image.file(_image!,height: 300,) : Image.network(image!,height: 300,),
                  ),
                  Text('About this product', style: TextStyle(fontSize: 20),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: null,
                      controller: _descriptionText,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          'Catergory',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: AbsorbPointer(
                            absorbing: true, //this will block user enter category manually
                            child: TextFormField(
                              controller: _categoryTextController,
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Select Catergory Name';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Not Selected', //
                                labelStyle: TextStyle(color: Colors.grey),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit_outlined),
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return CategoryList();
                                }
                            ).whenComplete(() {
                              setState(() {
                                _categoryTextController.text=
                                    _provider.selectedCategory;
                                _visible = true;
                              });
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  //subCatergoryStart
                  // Visibility(
                  //   visible: _visible,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(top : 10,bottom: 20),
                  //     child: Row(
                  //       children:[
                  //         Text(
                  //           'Sub Category',
                  //           style: TextStyle(color: Colors.grey,fontSize: 16),
                  //         ),
                  //         SizedBox(width: 10,),
                  //         Expanded(
                  //           child: AbsorbPointer(
                  //             absorbing: true, //this will block user enter category manually
                  //             child: TextFormField(
                  //               controller: _subCategoryTextController,
                  //               validator: (value){
                  //                 if(value!.isEmpty){
                  //                   return 'Select Sub Catergory Name';
                  //                 }
                  //                 return null;
                  //               },
                  //               decoration: const InputDecoration(
                  //                 hintText: 'Not Selected', //
                  //                 labelStyle: TextStyle(color: Colors.grey),
                  //                 enabledBorder: UnderlineInputBorder(
                  //                   borderSide: BorderSide(
                  //                     color: Colors.grey,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         IconButton(
                  //           icon: Icon(Icons.edit_outlined),
                  //           onPressed: (){
                  //             showDialog(
                  //                 context: context,
                  //                 builder: (BuildContext context){
                  //                   return SubCategoryList();
                  //                 }
                  //             ).whenComplete(() {
                  //               setState(() {
                  //                 _subCategoryTextController.text=
                  //                     _provider.selectedSubCategory;
                  //               });
                  //             });
                  //           },
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  //subCategoryEnd
                  Container(
                    child: Row(
                      children: [
                        Text(
                          'Collection',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        DropdownButton<String>(
                          hint: Text('Select Collection'),
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_drop_down),
                          onChanged: (String? value) {
                            setState(() {
                              dropdownValue = value!;
                            });
                          },
                          items: _collections
                              .map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text('Stock : '),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          controller: _stockTextController,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Low Stock : '),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          controller: _lowStockTextController,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Tax % : '),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          controller: _taxTextController,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


