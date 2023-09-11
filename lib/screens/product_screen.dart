import 'package:flutter/material.dart';
import 'package:shoppingmall/screens/add_newproduct_screen.dart';


class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(

          children: [
            Material(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        child: Row(
                          children: [
                            Text('products'),
                            SizedBox(width: 10,),
                            CircleAvatar(
                              backgroundColor: Colors.black45,
                              maxRadius: 8,
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text('20',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                ),
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                    TextButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                      ),
                      icon: Icon(Icons.add),
                      label: Text('Add New',style: TextStyle(color:Colors.white),),
                      onPressed: (){
                        Navigator.pushNamed(context, AddNewProduct.id);
                      },
                    )
                  ],
                ),
              ),
            ),
            TabBar(
              indicatorColor: Theme.of(context).primaryColor ,
              labelColor: Theme.of(context).primaryColor ,
              unselectedLabelColor: Colors.black54,
              tabs: [
                Tab(text:'PUBLISHED',),
                Tab(text:'UN PUBLISHED'),
              ],
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                    children: [
                      Center(child: Text('published Products'),),
                      Center(child: Text('Un published Products'),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
