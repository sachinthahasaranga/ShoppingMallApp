import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmall/services/firebase_services.dart';


class UnPublishedProducts extends StatelessWidget {
  const UnPublishedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    
    FirebaseServices _services = FirebaseServices();
    return Container(
      child: StreamBuilder(
        stream: _services.products.where('published',isEqualTo: false).snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Text('Something went wrong...');
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          return SingleChildScrollView(
            child: DataTable(
              showBottomBorder: true,
              dataRowMaxHeight: 60,
              headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
              columns: <DataColumn>[
                DataColumn(label: Expanded(child: Text('Product')),),
                DataColumn(label: Text('Image'),),
                DataColumn(label: Text('Actions'),),
              ],
              rows: _productDetails(snapshot.data),
            ),
          );
        }
      ),
    );

  }


  List<DataRow> _productDetails(QuerySnapshot<Object?>? snapshot) {
    if (snapshot == null || snapshot.docs.isEmpty) {
      return []; // Return an empty list when the snapshot is null or empty.
    }

    List<DataRow?> newList = snapshot.docs.map((DocumentSnapshot<Object?> document) {
      if (document != null) {
        final data = document.data() as Map<String, dynamic>?;
        final productName = data?['productName'] as String;
        final productImage = data?['productImage'] as String;
        final sku = data?['sku'] as String;

        return DataRow(
          cells: [
            DataCell(
              Container(child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    Expanded(child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15))),
                    Expanded(child: Text(productName, style: TextStyle(fontSize: 15))),
                  ],
                ),
                subtitle: Row(
                  children: [
                    Text('SKU:  ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                    Text(sku, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),),
            ),
            DataCell(
              Container(child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Image.network(productImage),
              ),),
            ),
            DataCell(
              popUpButton(data)
            ),
          ],
        );
      }
    }).toList();
    return newList.where((dataRow) => dataRow != null).cast<DataRow>().toList();
  }

  Widget popUpButton(data,{BuildContext? context}){

    FirebaseServices _services = FirebaseServices();
    
    return PopupMenuButton<String>(
        onSelected: (String value){
          if(value=='publish'){
            _services.publishProduct(
                id: data['productId'],
            );
          }

          if(value=='delete'){
            _services.deleteProduct(
              id: data['productId'],
            );
          }

        },
        itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'publish',
            child: ListTile(
              leading: Icon(Icons.check),
              title: Text('Publish'),
              ),),

          const PopupMenuItem<String>(
            value: 'preview',
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Preview'),
            ),),

          const PopupMenuItem<String>(
            value: 'edit',
            child: ListTile(
              leading: Icon(Icons.edit_outlined),
              title: Text('Edit Product'),
            ),),

          const PopupMenuItem<String>(
            value: 'delete',
            child: ListTile(
              leading: Icon(Icons.delete_outline),
              title: Text('Delete Product'),
            ),),
        ]
    
    
    );

  }



}



