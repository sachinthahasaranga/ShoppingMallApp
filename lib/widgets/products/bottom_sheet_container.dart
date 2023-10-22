import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shoppingmall/widgets/products/save_for_later.dart';

import 'add_wishlist_widget.dart';

class  BottomSheetContainer extends StatefulWidget {
//Flexible(child: CounterWidget(widget.document , widget.qty))
  final DocumentSnapshot document;
  final int qty;

  BottomSheetContainer(this.document , this.qty);

  @override
  State<BottomSheetContainer> createState() => _State();
}

class _State extends State<BottomSheetContainer> {
  late final int qty;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [

          //Flexible(flex: 1, child: SaveForLater(widget.document)),
          Flexible(flex: 1, child: AddWishlistWidget(widget.document))
        ],
      ),
    );
  }
}
