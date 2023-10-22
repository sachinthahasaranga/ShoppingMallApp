import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shoppingmall/screens/product_details_screen.dart';
import '../cart/counter.dart';

class ProductCard extends StatelessWidget {
  final DocumentSnapshot document;

  ProductCard(this.document);

  @override
  Widget build(BuildContext context) {
    final data = document.data() as Map<String, dynamic>?;
    final productImage = data?['productImage'] as String? ?? '';
    final brand = data?['brand'] as String? ?? '';
    final productName = data?['productName'] as String? ?? '';
    final price = (data?['price'] as num?)?.toDouble() ?? 0.0;
    final weight = data?['weight'] as String? ?? '';
    final comparedPrice = (data?['comparedPrice'] as num?)?.toDouble() ?? 0.0;

    String offer = ((comparedPrice - price) / comparedPrice * 100).toStringAsFixed(0);

    return Container(
      height: 160,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
        child: Row(
          children: [
            Column(
              children: [
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: ProductDetailsScreen.id),
                        screen: ProductDetailsScreen(document),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                    },
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Image.network(productImage),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(9),
                      bottomRight: Radius.circular(9),
                    ),
                  ),
                  child: Text('$offer% offer', style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(brand, style: TextStyle(fontSize: 10)),
                        SizedBox(height: 6),
                        Text(
                          productName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Container(
                          width: MediaQuery.of(context).size.width - 160,
                          padding: EdgeInsets.only(top: 10, bottom: 10, left: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.grey[200],
                          ),
                          child: Text(
                            weight,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Text('\$$price', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(width: 10),
                            Text(
                              '\$$comparedPrice',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 160,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CounterForCard(
                               document,
                              onQuantityChanged: (int newQuantity) {
                                // Handle the quantity change here
                                // You can update the parent widget's state with the new quantity
                                // For example, you can update a List of quantities for each product
                                // or any other state management approach you are using.
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
