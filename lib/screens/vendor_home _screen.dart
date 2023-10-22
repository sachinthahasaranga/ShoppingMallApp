
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/store_provider.dart';
import 'package:shoppingmall/widgets/categories_widget.dart';
import 'package:shoppingmall/widgets/image_slider.dart';
import 'package:shoppingmall/widgets/my_appbar.dart';
import 'package:shoppingmall/widgets/products/best_selling_product.dart';
import 'package:shoppingmall/widgets/products/featured_product.dart';
import 'package:shoppingmall/widgets/products/recently_added_products.dart';
import 'package:shoppingmall/widgets/vendor_appbar.dart';
import 'package:shoppingmall/widgets/vendor_banner.dart';
import 'package:shoppingmall/widgets/products/featured_product.dart';

class VendorHomeScreen extends StatelessWidget {
  static const String id = 'vendor_screen';

  const VendorHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _store = Provider.of<StoreProvider>(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            VendorAppbar(),
          ];
        },
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            VendorBanner(),
            VendorCategories(),
            //recently added product
            //best selling product
            //featured product
            RecentlyAddedProducts(),
            FeaturedProduct(),
            BestSellingProduct(),

          ],
        ),
      ),
    );
  }
}
