import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shoppingmall/widgets/products/bottom_sheet_container.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String id = 'product_details_screen';
  final DocumentSnapshot? document;
  //final int qty;// Make the document nullable

  ProductDetailsScreen(this.document);

  @override
  Widget build(BuildContext context) {
    double offer = 0.0;
    if (document != null && document!.exists) {
      final data = document!.data() as Map<String, dynamic>?;

      if (data != null) {
        final comparedPrice = (data['comparedPrice'] as num?)?.toDouble();
        final price = (data['price'] as num?)?.toDouble();

        if (comparedPrice != null && price != null && comparedPrice > 0) {
          offer = ((comparedPrice - price) / comparedPrice) * 100;
        }
      }
    }

    if (document == null || !document!.exists) {
      // Handle the case where the document is null or doesn't exist
      return Scaffold(
        appBar: AppBar(
          // Your app bar configuration
        ),
        body: Center(
          child: Text('Document not found'), // Display a message or handle the error as needed
        ),
      );
    }

    final data = document!.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>

    final int qty = data?['quantity'] as int? ?? 0;
    if (data == null) {
      // Handle the case where the document data is null
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          actions: [
            IconButton(icon: Icon(CupertinoIcons.search), onPressed: () {}),
          ],
        ),
        body: Center(
          child: Text('Document data is null'), // Display a message or handle the error as needed
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(icon: Icon(CupertinoIcons.search), onPressed: () {}),
        ],
      ),
      bottomSheet: BottomSheetContainer(document!,qty),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          // Your existing UI code here
          children: [
            Row(
              children: [
                Container(
                  // Your container configuration
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 2,
                      top: 2,
                    ),
                    child: Text(
                      data?['brand'] as String? ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 9),
            Text(data?['productName'] as String? ?? '', style: TextStyle(fontSize: 22)),
            SizedBox(height: 9),
            Text(data?['weight'] as String? ?? '', style: TextStyle(fontSize: 19)),
            SizedBox(height: 9),
            Row(
              children: [
                Text(
                  '\$${(data?['price'] as num?)?.toDouble()?.toStringAsFixed(0) ?? '0'}',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 9),
                Text(
                  '\$${(data?['comparedPrice'] as num?)?.toDouble()?.toStringAsFixed(0) ?? '0'}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                SizedBox(width: 9),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 3,
                      bottom: 3,
                    ),
                    child: Text(
                      '${offer.toStringAsFixed(0)}% off',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 9),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                data?['productImage'] as String? ?? '',
                fit: BoxFit.scaleDown,
                width: 200,
                height: 200,
              ),
            ),
            Divider(color: Colors.grey[300], thickness: 6),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  'About this product',
                  style: TextStyle(fontSize: 19),
                ),
              ),
            ),
            Divider(color: Colors.grey[300]),
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: 10,
                right: 10,
              ),
              child: ExpandableText(
                data?['description'] as String? ?? '',
                expandText: 'view more',
                collapseText: 'view less',
                maxLines: 2,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Divider(color: Colors.grey[300]),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  'other product info',
                  style: TextStyle(fontSize: 19),
                ),
              ),
            ),
            Divider(color: Colors.grey[300]),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 8,
                bottom: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SKU  ${data?['sku'] as String? ?? ''}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Seller  ${data?['seller']['shopName'] as String? ?? ''}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Future<void> saveForLater() async {
    CollectionReference _favourite =
    FirebaseFirestore.instance.collection('favourite');

    User? user = FirebaseAuth.instance.currentUser;
    await _favourite.add({
      'product' :document!.data(),
      'customerId' : user!.uid,
    });
  }
}
