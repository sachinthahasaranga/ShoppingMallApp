
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class CouponWidget extends StatefulWidget {
  const CouponWidget({super.key});

  @override
  State<CouponWidget> createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {
  Color color = Colors.grey;
  bool _enable = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10 , left: 10),
            child: Row(
              children: [
                Expanded(child: SizedBox(
                  height: 36,
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[400],
                      hintText: 'Enter voucher code',
                      hintStyle: TextStyle(color: Colors.grey),

                    ),
                    onChanged: (String value){
                      if(value.length < 3){
                        setState(() {
                          color = Colors.grey;
                          _enable = false;
                        });
                        if(value.isNotEmpty){
                          setState(() {
                            color = Theme.of(context).primaryColor;
                            _enable = true;
                          });
                        }
                      }
                    },
                  ),
                ),
                ),
                AbsorbPointer(
                  absorbing: _enable ? false :true,
                  child: OutlinedButton(
                      onPressed: (){
                        print('aaaabb');
                      }, child: Text('Apply')),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DottedBorder(child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.deepOrangeAccent.withOpacity(.4),
                      ),
                      width: MediaQuery.of(context).size.width-80,
                      height: 90,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text('jam001'),
                          ),
                          Divider(color: Colors.grey[900],),
                          Text('new year special discount'),
                          Text('30% discount on total purchase'),
                          SizedBox(height: 10,)
                        ],
                      ),
                    ),
                    Positioned(
                        right: -5.0 ,
                        top: -10,
                        child: IconButton(icon: Icon(Icons.clear), onPressed: () {  },))
                  ],
                ),
              ],
            ),),
          ),
        ],
      ),
    );
  }
}
