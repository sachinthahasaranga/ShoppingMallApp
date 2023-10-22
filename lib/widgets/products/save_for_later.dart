import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SaveForLater  extends StatelessWidget {

  final DocumentSnapshot document;

  SaveForLater(this.document);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        EasyLoading.show(status: 'saving');
        saveForLater().then((value) {
          EasyLoading.showSuccess('saved success');
        });
      },
      child: Container(
        height: 56,
        color: Colors.grey[800],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.bookmark),
                SizedBox(width: 9),
                Text(
                  'save for later',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> saveForLater() async {
    CollectionReference _favourite =
    FirebaseFirestore.instance.collection('favourite');

    User user = FirebaseAuth.instance.currentUser!;

    await _favourite.add({
      'product' :document.data(),
      'customerId' : user.uid,
    });
  }
}


