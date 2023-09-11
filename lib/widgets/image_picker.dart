import 'package:flutter/material.dart';

class ShopPicCard extends StatelessWidget {
  const ShopPicCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150,
        width: 150,
        child: Card(
            child: Text('Add Shop Image'),
            ),
        );
    }
}