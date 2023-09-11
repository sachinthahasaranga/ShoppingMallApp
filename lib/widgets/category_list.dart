import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/product_provider.dart';
import 'package:shoppingmall/services/firebase_services.dart';


class CategoryList extends StatefulWidget {
  const CategoryList({super.key});


  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {


  FirebaseServices _services = FirebaseServices();

  @override
  Widget build(BuildContext context) {

    var _provider = Provider.of<ProductProvider>(context);

    return Dialog(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select Category',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  IconButton(
                    icon: Icon(Icons.close,color: Colors.white,),
                    onPressed: (){
                      Navigator.pop(context);

                    },
                  )
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: _services.category.snapshots(),
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
                if(snapshot.hasError){
                  return Text('Something Went wrong...');
                }
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }
                return Expanded(
                  child: ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      final data = document.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic> or the appropriate type
                      final imageUrl = data?['image'] as String?; // Cast 'image' to String or the appropriate type
                      final name = data?['name'] as String?; // Cast 'name' to String or the appropriate type

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,                        ),
                        title: Text(name ?? 'N/A'),
                        onTap: (){
                          _provider.selectCategory(name);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),

                  ),
                );
              }
          ),

        ],
      ),
    );
  }
}

class SubCategoryList extends StatefulWidget {
  const SubCategoryList({super.key});

  @override
  State<SubCategoryList> createState() => _SubcategoryListState();
}

class _SubcategoryListState extends State<SubCategoryList> {
  FirebaseServices _services = FirebaseServices();

  @override
  Widget build(BuildContext context) {

    var _provider = Provider.of<ProductProvider>(context);

    return Dialog(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select Sub Category',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  IconButton(
                    icon: Icon(Icons.close,color: Colors.white,),
                    onPressed: (){
                      Navigator.pop(context);

                    },
                  )
                ],
              ),
            ),
          ),
          FutureBuilder<DocumentSnapshot>(
              future: _services.category.doc(_provider.selectedCategory).get(),
              builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot>snapshot){
                if(snapshot.hasError){
                  return Text('Something Went wrong...');
                }
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }
                //Map<String, dynamic>data= snapshot.data.data();
                Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;

                return Expanded(
                  child: Column(
                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Row(
                            children: [
                              Text('Main Category :  '),
                              FittedBox(child: Text(_provider.selectedCategory,style: TextStyle(fontWeight: FontWeight.bold ),)),
                            ],
                          ),
                        ),
                      ),
                      Divider(thickness: 3,),
                      Container(
                        child: Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView.builder(
                                itemBuilder: (BuildContext context, int index){
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      child: Text('${index + 1}'),
                                    ),
                                    //title: Text(data['subCat'][index]['name']),
                                    // onTap: (){
                                    //   _provider.selectSubCategory(data['subCat'][index]['name']);
                                    //   Navigator.pop(context);
                                    // },
                                    //need to check and correct

                                  );
                                },
                              //itemCount: data['subCat']==null ? 0: data['subCat'].length,
                              //need to check and correct

                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                );
              }
          ),

        ],
      ),
    );
  }
}


