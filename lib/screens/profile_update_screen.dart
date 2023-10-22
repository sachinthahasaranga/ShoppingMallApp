
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shoppingmall/services/user_services.dart';

class UpdateProfile extends StatefulWidget {
  static const String id = 'update-profile';

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();

  User? user = FirebaseAuth.instance.currentUser;
  var firstName = TextEditingController();
  var lastName = TextEditingController();

  UserServices _user = UserServices();
  var mobile = TextEditingController();
  var email = TextEditingController();

  updateProfile() {
    return FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
      'firstName': firstName.text,
      'lastName': lastName.text,
      'email': email.text,
    });
  }

  @override
  void initState() {
    super.initState();

    _user.getUserById(user!.uid).then((value) {
      if (mounted) {
        setState(() {
          firstName.text = value?['firstName'] ?? '';
          lastName.text = value?['lastName'] ?? '';
          email.text = value?['email'] ?? '';
        });

      }
    });

    // Initialize the mobile controller directly
    mobile = TextEditingController(text: user!.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Update Profile',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      bottomSheet: InkWell(
        onTap: () {
          if(_formKey.currentState!.validate()){
            EasyLoading.show(status: 'Updating profile');
            updateProfile().then((value) {
              EasyLoading.showSuccess('Updated successfully');
              Navigator.pop(context);
            });
          }
        },
        child: Container(
          width: double.infinity,
          height: 89,
          color: Colors.blueGrey[900],
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 69),
              child: Text(
                'Update',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(19.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: firstName,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.zero,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter First Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 19),
                  Expanded(
                    child: TextFormField(
                      controller: lastName,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.zero,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Last Name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(width: 29),
              TextFormField(
                controller: mobile,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Mobile',
                  labelStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.zero,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Email';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
