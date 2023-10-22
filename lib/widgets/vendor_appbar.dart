import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/store_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorAppbar extends StatelessWidget {
  const VendorAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    var _store = Provider.of<StoreProvider>(context);
    return SliverAppBar(
      floating: true,
      snap: true,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      expandedHeight: 260,
      flexibleSpace: SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(top: 86),
            child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(_store.storedetails['imageUrl']),
                        )
                    ),
                    child: Container(
                      color: Colors.grey.withOpacity(.6),
                      child: ListView(
                        children: [
                          Text(_store.storedetails['dialog'] , style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          Text(_store.storedetails['email'] , style: TextStyle(color: Colors.white),),
                          SizedBox(height: 6,),
                          Row(
                            children: [
                              Icon(Icons.star , color: Colors.white,),
                              Icon(Icons.star , color: Colors.white,),
                              Icon(Icons.star , color: Colors.white,),
                              Icon(Icons.star_half , color: Colors.white,),
                              Icon(Icons.star_outline , color: Colors.white,),
                              SizedBox(width: 6,),
                              Text('(3.6)' , style: TextStyle(color: Colors.white),)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(icon: Icon(Icons.phone , color: Theme.of(context).primaryColor,), onPressed: () {
                                  launch('tel: ${_store.storedetails['mobile']}');
                                },),
                              ),
                              SizedBox(width: 4,),
                            ],
                          )
                        ],
                      ),
                    ),

                  ),
                )),
          )),
      actions: [
        IconButton(
          onPressed: () {

          },
          icon: Icon(CupertinoIcons.search),
        ),
      ],
      title: Text(
        _store.storedetails['shopName'],
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}