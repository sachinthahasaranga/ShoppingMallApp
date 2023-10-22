import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/widgets/products/product_list.dart';
import 'package:shoppingmall/widgets/vendor_appbar.dart';

import '../providers/store_provider.dart';

class ProductListScreen extends StatelessWidget {
  static const String id = 'product-list-screen';

  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<StoreProvider>(context);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(
                _storeProvider.selectedProductCategory,
                style: TextStyle(color: Colors.white),
              ),
              iconTheme: IconThemeData(color: Colors.white),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  ProductListWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
