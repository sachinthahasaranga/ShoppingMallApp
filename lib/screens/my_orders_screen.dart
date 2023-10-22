import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({Key? key});

  Future<void> generatePdf() async {
    final pdf = pw.Document();

    final ByteData fontData = await rootBundle.load('assets/NotoSans-Regular.ttf');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Text(
              'Customer Useful Report',
              style: pw.TextStyle(font: ttf, fontSize: 24),
            ),
          );
        },
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/customer_report.pdf');
    await tempFile.writeAsBytes(await pdf.save());

// You can now open or share this file
// Example: Open the file using a PDF viewer
// FileOpener.open(tempFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'WishList History',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.picture_as_pdf, color: Colors.white),
            onPressed: () async { // Mark the function as async
              await generatePdf(); // Use the 'await' keyword here
            },
          ),
        ],
      ),
      body: OrderList(),
    );
  }
}
class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No orders, continue shopping'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final document = snapshot.data!.docs[index];
            final data = document.data() as Map<String, dynamic>;

            final orderStatus = data['orderStatus'] ?? 'Unknown Status';
            final timestampStr = data['timestamp'] as String?;
            final orderDate = timestampStr != null
                ? DateTime.tryParse(timestampStr)
                : null;

            final products = data['products'] as List<dynamic>?;

            return Card(
              margin: EdgeInsets.all(8.0),
              elevation: 4.0,
              child: ExpansionTile(
                title: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 20,
                    child: Icon(Icons.shopping_cart, color: Colors.white),
                  ),
                  title: Text(
                    orderStatus,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  subtitle: Text(
                    orderDate != null
                        ? 'Placed on ${DateFormat.yMMMd().format(orderDate)}'
                        : 'Timestamp not available',
                  ),
                ),
                children: [
                  if (products != null)
                    for (final product in products)
                      ProductListItem(product: product),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class ProductListItem extends StatelessWidget {
  final dynamic product;

  ProductListItem({required this.product});

  @override
  Widget build(BuildContext context) {
    final productName = product['productName'] ?? 'Product Name N/A';
    final productImage = product['productImage'] ?? 'Product Image URL N/A';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Image.network(
          productImage,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(
          productName,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
