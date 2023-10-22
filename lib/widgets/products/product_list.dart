import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/store_provider.dart';
import 'package:shoppingmall/services/product_services.dart';
import 'package:shoppingmall/widgets/products/product_card_widget.dart';

class ProductListWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    var _storeProvider = Provider.of<StoreProvider>(context);
    return FutureBuilder<QuerySnapshot>(
      future: _services.products.where('published' , isEqualTo: true).where('category.mainCategory' ,isEqualTo: _storeProvider.selectedProductCategory).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(),
          );
        }


        if(snapshot.data!.docs.isEmpty){
          return Container();
        }

        return Column(
          children: [
            Container(
              height: 60 , color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.only(left: 8,right: 8),
                child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 6, right: 2),
                      child: Chip(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)
                        ),
                        label: Text('All'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 9),
                    child: Text('${snapshot.data!.docs.length} Items' , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.grey[600]),),
                  ),
                ],
              ),
            ),

            new ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return new ProductCard(document);
              })
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}
