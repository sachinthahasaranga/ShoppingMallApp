import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/widgets/category_list.dart';

import '../providers/product_provider.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({super.key});
  static const String id = 'addnewproduct - screen';

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formkey = GlobalKey<FormState>();

  List<String> _collections = [
    'Featured products',
    'Best Selling',
    'Recently Added',
  ];
  String? dropdownValue = 'Featured products';

  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();
  var _comparedPriceTextController = TextEditingController();
  var _brandTextController = TextEditingController();
  var _lowStockTextController = TextEditingController();
  var _stockTextController = TextEditingController();

  File? _image;
  bool _visible = false;
  bool _track = false;

  String? productName;
  String? description;
  double? price;
  double? comparedPrice;
  String? sku;
  String? weight;
  double? tax;
  //int? stockQty;


  @override
  Widget build(BuildContext context) {

    var _provider = Provider.of<ProductProvider>(context);

    return DefaultTabController(
      length: 2,
      initialIndex: 1,  //will keep initial index 1 to avoid textfeild clearing automatically
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _formkey,
          child: Column(
            children: [
              Material(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          child: Text('products / Add'),
                        ),
                      ),
                      TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                        ),
                        icon: Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if(_formkey.currentState!.validate()){
                            //only if filled neccessary field
                            if(_categoryTextController.text.isNotEmpty){
                             //if(_subCategoryTextController.text.isNotEmpty){
                                if(_image!=null){
                                  //image should be selected
                                  //upload image to storage
                                  EasyLoading.show(status: 'Saving...');
                                  _provider.uploadProductImage(_image!.path, productName).then((url){
                                    if(url!=null){
                                      //upload product data to firestore
                                      EasyLoading.dismiss();
                                      _provider.saveProductDataToDb(
                                        context: context,
                                        comparedPrice: int.parse(_comparedPriceTextController.text),
                                        brand: _brandTextController.text,
                                        collection: dropdownValue,
                                        description: description,
                                        lowStockQty: int.parse(_lowStockTextController.text),
                                        price: price,
                                        sku: sku,
                                        stockQty: int.parse(_stockTextController.text),
                                        tax: tax,
                                        weight: weight,
                                        productName: productName,

                                      );

                                      setState(() {

                                        //clear all the existing values after saved
                                        _formkey.currentState?.reset();
                                        _comparedPriceTextController.clear();
                                        dropdownValue = null;
                                        //_subCategoryTextController.clear();
                                        _categoryTextController.clear();
                                        _brandTextController.clear();
                                        _track = false;
                                        _visible = false;
                                      });

                                    }
                                    else{
                                      //upload failed
                                      _provider.alertDialog(
                                        context: context,
                                        title: 'IMAGE UPLOAD',
                                        content: 'Faild to upload product image',
                                      );
                                    }
                                  });
                                }
                                else{
                                  //image not selected
                                  _provider.alertDialog(
                                    context: context,
                                    title: 'PRODUCT IMAGE',
                                    content: 'Product Image not selected',
                                  );
                                }
                              //}
                              // else{
                              //   _provider.alertDialog(
                              //       context: context,
                              //       title: 'Sub Catergory',
                              //       content: 'Sub catergory not selected'
                              //   );
                              // }

                            } else{
                              _provider.alertDialog(
                                context: context,
                                title: 'Main Catergory',
                                content: 'Main catergory not selected'
                              );
                            }

                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(
                    text: 'GENERAL',
                  ),
                  Tab(
                    text: 'INVENTORY',
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: TabBarView(
                      children: [
                        ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  TextFormField(
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'Enter Product Name';
                                      }
                                      setState(() {
                                        productName = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Product Name',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    maxLength: 500,

                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'Enter Description';
                                      }
                                      setState(() {
                                        description = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'About product',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: (){
                                        _provider.getProductImage().then((image) {
                                          setState(() {
                                            _image = image;
                                          });
                                        });
                                      },

                                      child: SizedBox(
                                        width: 150,
                                        height: 150,
                                        child: Card(
                                          child: Center(
                                            child: _image==null? Text('Select Image') : Image.file(_image!),

                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'Enter selling price';
                                      }
                                      setState(() {
                                        price = double.parse(value);
                                      });
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Price', //final setting price
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _comparedPriceTextController,
                                    validator: (value){
                                      //not compulsory
                                      // if(value!.isEmpty){
                                      //   return 'Enter Compared price';
                                      // }
                                      if(price!>double.parse(value!)){
                                        return 'Compared price should be heigher than price';
                                      }

                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText:
                                          'Compared Price', //price before discount
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
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
                                  TextFormField(
                                    controller: _brandTextController,
                                    decoration: const InputDecoration(
                                      //validator not compulsory
                                      labelText: 'Brand',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'Enter SKU';
                                      }
                                      setState(() {
                                        sku = value;
                                      });
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'SKU', //item code
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
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
                                                      _provider.selectedCategory!;
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
                                  TextFormField(
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'Select Weight';
                                      }
                                      setState(() {
                                        weight = value;
                                      });
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Weight. eg:- Kg, gm, etc', //item weight
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'Select Weight';
                                      }
                                      setState(() {
                                        tax = double.parse(value);
                                      });
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Tax %', //item code
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          ],
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children:[
                              SwitchListTile(
                                title : Text('Track Inventory'),
                                activeColor: Theme.of(context).primaryColor,
                                subtitle: Text('Switch ON to track Inventory',
                                  style: TextStyle(
                                      color: Colors.grey,fontSize: 12
                                  ),
                                ),
                                value: _track,
                                onChanged: (selected){
                                  setState(() {
                                    _track = !_track;
                                  });
                                },
                              ),
                              Visibility(
                                visible: _track,
                                child: SizedBox(
                                  height: 300,
                                  width: double.infinity,
                                  child: Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: _stockTextController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              labelText: 'Inventory Quantity', //item code
                                              labelStyle: TextStyle(color: Colors.grey),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            //validation not compuslory
                                            keyboardType: TextInputType.number,
                                            controller: _lowStockTextController,
                                            decoration: const InputDecoration(
                                              labelText: 'Inventory Low Stock Quantity', //item code
                                              labelStyle: TextStyle(color: Colors.grey),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
