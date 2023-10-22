import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/store_provider.dart';
import 'package:shoppingmall/services/product_services.dart';

class ProductFilterWidget extends StatefulWidget {


  @override
  State<ProductFilterWidget> createState() => _ProductFilterWidgetState();
}


class _ProductFilterWidgetState extends State<ProductFilterWidget> {
  List _subCatList = [];
  ProductServices _services = ProductServices();

  @override
  void didChangeDependencies() {
    var _store = Provider.of<StoreProvider>(context);



    FirebaseFirestore.instance
        .collection('products').where('categorymainCategory' , isEqualTo: _store.selectedProductCategory)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _subCatList.add(doc['category']['subCategory']);
        });
      });
    });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    var _storeData = Provider.of<StoreProvider>(context);
    return FutureBuilder<DocumentSnapshot>(
      future: _services.category.doc(_storeData.selectedProductCategory).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if(!snapshot.hasData){
          return Container();
        }

       // if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Container(
            height: 60 , color: Colors.grey,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(width: 11,),
                ActionChip(
                    elevation: 4,
                    label: Text('All ${_storeData.selectedProductCategory}'), onPressed: (){
                },backgroundColor: Colors.white),
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  itemBuilder: (BuildContext context , int index){
                    return Padding(
                      padding: const EdgeInsets.only(left: 9),
                      child:
                          _subCatList.contains(data['subCat'][index]['name'])?
                      ActionChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)
                        ),
                          elevation: 4,
                          label: Text(data['subCat'][index]['name']), onPressed: (){
                      },backgroundColor: Colors.white):Container(),
                    );
                  },
                  itemCount: data.length,
                )

              ],
            )
          );
        //}

        //return Container();
      },
    );
  }
}
