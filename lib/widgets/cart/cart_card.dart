
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartCard extends StatefulWidget {
  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  List<QueryDocumentSnapshot> cartDocs = [];
  bool dataLoaded = false;

  void loadData() {
    FirebaseFirestore.instance.collection('cart').get().then((querySnapshot) {
      setState(() {
        cartDocs = querySnapshot.docs;
        dataLoaded = true;
      });
    }).catchError((error) {
      print('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return dataLoaded
        ? Column(
      children: cartDocs.map((cartDoc) {
        return CartItemWidget(cartDoc: cartDoc);
      }).toList(),
    )
        : ElevatedButton(
      onPressed: () {
        loadData();
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.grey[300], // Change the button's background color
        padding: EdgeInsets.all(16), // Adjust padding as needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // Customize the button's shape
        ),
      ),
      child: Text(
        '',
        style: TextStyle(
          color: Colors.white, // Change the text color to white
          fontSize: 18, // Adjust the text size
        ),
      ),
    );

  }
}

class CartItemWidget extends StatelessWidget {
  final QueryDocumentSnapshot cartDoc;

  CartItemWidget({required this.cartDoc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: cartDoc.reference.collection('product').snapshots(),
      builder: (context, productSnapshot) {
        if (productSnapshot.hasError) {
          return Text('Error: ${productSnapshot.error}');
        } else if (!productSnapshot.hasData || productSnapshot.data!.docs.isEmpty) {
          return SizedBox.shrink();
        } else {
          final productDocs = productSnapshot.data!.docs;
          final displayedProductIds = Set<String>();

          return Column(
            children: productDocs.where((productDoc) {
              final productData = productDoc.data() as Map<String, dynamic>;
              final productId = productData['productId'] ?? '';

              if (displayedProductIds.contains(productId)) {
                return false; // Skip this product if it has already been displayed.
              }

              //displayedProductIds.add(productId);
              return true;
            }).map((productDoc) {
              final productData = productDoc.data() as Map<String, dynamic>;
              final String productImage = productData['productImage'] ?? '';
              final String productName = productData['productName'] ?? '';
              final String weight = (productData['weight'] ?? 0.0).toString();
              final double comparedPrice = (productData['comparedPrice'] as num?)?.toDouble() ?? 0.0;
              final double price = (productData['price'] as num?)?.toDouble() ?? 0.0;
              final double saving = comparedPrice - price;

              return Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                productImage,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName,
                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                ),
                                Text(
                                  weight,
                                  style: TextStyle(fontSize: 13, color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                if (comparedPrice > 0)
                                  Text(
                                    '\$${comparedPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 12,
                                    ),
                                  ),
                                Text(
                                  '\$${price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          child: FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '\$${saving.toStringAsFixed(2)}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
