import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmall/services/firebase_services.dart';


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

  var _brandText = TextEditingController();
  var _skuText = TextEditingController();
  var _productNameText = TextEditingController();
  var _weightText = TextEditingController();
  var _priceText = TextEditingController();
  var _comparedPriceText = TextEditingController();

  DocumentSnapshot? doc;

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

        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
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
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      )
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


