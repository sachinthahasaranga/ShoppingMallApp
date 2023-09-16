import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/auth_provider.dart';

class ShopPicCard extends StatefulWidget {
  //const ShopPicCard({super.key});

  @override
  _ShopPicCardState createState() => _ShopPicCardState();
}

class _ShopPicCardState extends State<ShopPicCard> {
  late File _image = File(''); // Initialize with an empty file path or null

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          _authData.getImage().then((image) {
            if (image != null) {
              setState(() {
                _image = image;
                _authData.isPicAvail = true;
              });
            }print(_image.path);
          });
        },
        child: SizedBox(
          height: 150,
          width: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Card(
              child: _image == null
                  ? Center(
                child: Text(
                  'Add Shop Image',
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : Image.file(_image, fit: BoxFit.fill),
            ),
          ),
        ),
      ),
    );
  }

}