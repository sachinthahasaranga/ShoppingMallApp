import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/store_provider.dart';
import 'package:shoppingmall/screens/product_list_screen.dart';
import 'package:shoppingmall/widgets/products/product_list.dart';
import 'package:shoppingmall/services/product_services.dart';

class VendorCategories extends StatefulWidget {
  const VendorCategories({Key? key});

  @override
  State<VendorCategories> createState() => _VendorCategoriesState();
}

class _VendorCategoriesState extends State<VendorCategories> {
  ProductServices _services = ProductServices();
  List<String> _castList = [];

  @override
  void didChangeDependencies() {
    var _store = Provider.of<StoreProvider>(context);

    FirebaseFirestore.instance
        .collection('products')
        .where('seller.sellerUid', isEqualTo: _store.storedetails['uid'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var category = doc['category'] as Map<String, dynamic>?;
        if (category != null) {
          var mainCategory = category['mainCategory'] as String?;
          if (mainCategory != null) {
            setState(() {
              _castList.add(mainCategory);
            });
          }
        }
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    var _storeProvider = Provider.of<StoreProvider>(context);
    return FutureBuilder(
      future: _services.category.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong: ${snapshot.error}'));
        }
        if (_castList.isNotEmpty && snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return SingleChildScrollView(
            child: Wrap(
              direction: Axis.horizontal,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                var data = document.data() as Map<String, dynamic>?;

                if (data != null) {
                  var name = data['name'] as String?;
                  var image = data['image'] as String?;
                  if (name != null && _castList.contains(name) && image != null) {
                    return InkWell(
                      onTap: (){
                        _storeProvider.selectedCategory(name);
                        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                          context,
                          settings: RouteSettings(name: ProductListScreen.id),
                          screen: ProductListScreen(),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Container(
                          width: 120, height: 190,
                          child: Card(
                            elevation: 2, // Add elevation for a shadow effect
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey, // Border color
                                  width: 1.0, // Border width
                                ),
                              ),
                              child: Column(
                                children: [
                                  Center(
                                    child: Image.network(image),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8, right: 8),
                                    child: Center(child: Text(name)),
                                  ),
                                ],
                              ),
                            ),
                          )

                      ),
                    );
                  }
                }

                return Text('');
              }).toList(),
            ),
          );
        } else {
          return Center(child: Text('No data available.'));
        }
      },
    );
  }
}
