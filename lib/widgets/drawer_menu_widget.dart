import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/product_provider.dart';

class MenuWidget extends StatefulWidget {
  final Function(String) onItemClick;

  const MenuWidget({Key? key, required this.onItemClick}) : super(key: key);

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}



class _MenuWidgetState extends State<MenuWidget> {

  User? user =FirebaseAuth.instance.currentUser;
  var vendorData;

  @override
  void initState() {
    getVendorData();
    super.initState();
  }

  Future<DocumentSnapshot>getVendorData()async{

    var result = await FirebaseFirestore.instance.collection('vendors').doc(user!.uid).get();
    setState(() {
      vendorData = result;
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    var _provider= Provider.of<ProductProvider>(context);
    _provider.getShopName(vendorData!=null ?vendorData.data()['shopName']: '');
    
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FittedBox(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(//shop picture
                      radius: 30,
                      backgroundImage: NetworkImage(vendorData!=null ? vendorData.data()['imageUrl']: null), //show profile image
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text(
                    vendorData!=null ? vendorData.data()['shopName'] : 'Shop Name',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,)
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),

          SizedBox(
            height: 20,
          ),
          sliderItem('Dashboard', Icons.space_dashboard_outlined),
          sliderItem('Product', Icons.shopping_bag_outlined),
          sliderItem('Coupons', CupertinoIcons.gift),
          sliderItem('Orders', Icons.stacked_bar_chart),
          sliderItem('Setting', Icons.settings_outlined),
          sliderItem('LogOut', Icons.arrow_back_ios),

        ],
      ),
    );
  }


  Widget sliderItem(String title,IconData icons)=> InkWell(
    child: Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey
          )
        )
      ),
      child: SizedBox(
        height: 40,
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Icon(icons,color: Colors.black45,size: 18,),
              SizedBox(width: 10,),
              Text(title,style: TextStyle(color:Colors.black45,fontSize: 12),)
            ],
          ),
        ),
      ),
      ),
      onTap: (){
        widget.onItemClick(title);

      }
  );


}
