import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/services/product_services.dart';
import 'package:shoppingmall/widgets/products/product_card_widget.dart';

import '../../providers/store_provider.dart';

class BestSellingProduct extends StatelessWidget {

  @override

  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    var _store = Provider.of<StoreProvider>(context);
    return FutureBuilder<QuerySnapshot>(
      future: _services.products.where('published' , isEqualTo: true).where('collection' ,isEqualTo: 'Best Selling').where('seller.sellerUid', isEqualTo: _store.storedetails['uid']).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if(!snapshot.hasData){
          return Container();
        }


        if(snapshot.data!.docs.isEmpty){
          return Container();
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 56,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center the text vertically
                    children: [
                      Text(
                        'Best Selling',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            new ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return new ProductCard(document);
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
