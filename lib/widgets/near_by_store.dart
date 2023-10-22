
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/store_provider.dart';
import 'package:shoppingmall/services/store_service.dart';

class NearByStores extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    StoreServices _storeServices = StoreServices();
    final _storeData = Provider.of<StoreProvider>(context);
    return Container(
      color: Colors.white,
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getTopPickedStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (!snapShot.hasData) {
            return CircularProgressIndicator();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 8.0),
                      child: Text(
                        'All Stores',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 8),
                      child: Text(
                        'Findout Quality Products Around You',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                color: Colors.white,
                height: 300, // Adjust the height as needed
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  // Use vertical scrolling here
                  itemCount: snapShot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapShot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Card(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  document['imageUrl'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // Add spacing between the image and text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  document['shopName'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF261B65),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  document['dialog'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black38,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Icon(Icons.star, size: 12, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text('3.2', style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );


                  },
                ),
              ),

              // Footer Section
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  child: Stack(
                    children: [
                      Center(
                        child: Text('*That\'s all folks*', style: TextStyle(color: Colors.grey)),
                      ),
                      Positioned(
                        right: 10.0,
                        top: 80,
                        child: Container(
                          width: 100,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          );
        },
      ),
    );
  }
}