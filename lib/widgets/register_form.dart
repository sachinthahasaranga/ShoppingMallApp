import 'dart:ffi';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/auth_provider.dart';
import 'package:shoppingmall/screens/home_screen.dart';

class RegisterForm extends StatefulWidget {

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _cPasswordTextController = TextEditingController();
  var _addressTextController = TextEditingController();
  var _nameTextController = TextEditingController();
  var _dialogTextController = TextEditingController();

  late String email;
  late String password;
  late String mobile;
  late String shopName;
  bool _isLoading = false;

  Future<String> uploadFile(filePath) async{
    File file = File(filePath);

    FirebaseStorage _storage = FirebaseStorage.instance;

    try{
      await _storage.ref('uploads/shopProfilePic/${_nameTextController.text}').putFile(file);
    }on FirebaseException catch (e){
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('uploads/shopProfilePic/${_nameTextController.text}').getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    scaffoldMessage(message) {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }


    return _isLoading ? CircularProgressIndicator(
      valueColor:AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    ):Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              validator: (value){
                if(value!.isEmpty){
                  return 'Enter Shop Name';
                }
                setState(() {
                  _nameTextController.text = value;
                });
                setState(() {
                  shopName = value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.add_business, color: Color(0xFF9E6CDA)),
                labelText: 'Business Name',
                labelStyle: TextStyle(color: Color(0xFF9E6CDA)),
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Color(
                        0xFF9E6CDA)
                    )
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              maxLength: 9,
              validator: (value){
                if(value!.isEmpty){
                  return 'Enter Mobile Number';
                }
                setState(() {
                  mobile = value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixText: '+94',
                prefixIcon: Icon(Icons.phone_android, color: Color(0xFF9E6CDA)),
                labelText: 'Mobile Number',
                labelStyle: TextStyle(color: Color(0xFF9E6CDA)),
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Color(
                        0xFF9E6CDA)
                    )
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              controller: _emailTextController,
              keyboardType: TextInputType.emailAddress,
              validator: (value){
                if(value!.isEmpty){
                  return 'Enter E-mail Address';
                }
                final bool _isValid = EmailValidator.validate(_emailTextController.text);
                if(!_isValid){
                  return 'Invalid Email Format';
                }
                setState(() {
                  email=value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF9E6CDA)),
                labelText: 'E-Mail Address',
                labelStyle: TextStyle(color: Color(0xFF9E6CDA)),
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Color(
                        0xFF9E6CDA)
                    )
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              obscureText: true,
              validator: (value){
                if(value!.isEmpty){
                  return 'Enter Password';
                }
                if(value.length<6){
                  return 'Minimum 6 Characters';
                }
                setState(() {
                  password=value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key_outlined, color: Color(0xFF9E6CDA)),
                labelText: 'Password',
                labelStyle: TextStyle(color: Color(0xFF9E6CDA)),
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Color(
                        0xFF9E6CDA)
                    )
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              obscureText: true,
              validator: (value){
                if(value!.isEmpty){
                  return 'Enter Confirm Password';
                }
                if(value.length<6){
                  return 'Minimum 6 Characters';
                }
                if(_passwordTextController.text != _cPasswordTextController.text){
                  return 'Password does not match.';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key_outlined, color: Color(0xFF9E6CDA)),
                labelText: 'Confirm Password',
                labelStyle: TextStyle(color: Color(0xFF9E6CDA)),
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Color(
                        0xFF9E6CDA)
                    )
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          /*Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              maxLines: 6,
              controller: _addressTextController,
              validator: (value){
                if(value!.isEmpty){
                  return 'Press on Navigation Button';
                }
                if(_authData.shopLatitude==null){
                  return 'Press on Navigation Button';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.contact_mail_outlined, color: Color(0xFF9E6CDA)),
                labelText: 'Business Location',
                labelStyle: TextStyle(color: Color(0xFF9E6CDA)),
                contentPadding: EdgeInsets.zero,
                suffixIcon: IconButton(onPressed: (){
                  _addressTextController.text='Locating...\n Please Wait';
                  _authData.getCurrentAddress().then((address) {
                    if(address!=null){

                    }
                  });
                }, icon: Icon(Icons.location_searching),),
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Color(
                        0xFF9E6CDA)
                    )
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              onChanged: (value){
                _dialogTextController.text=value;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.comment, color: Color(0xFF9E6CDA)),
                labelText: 'Shop Description',
                labelStyle: TextStyle(color: Color(0xFF9E6CDA)),
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Color(
                        0xFF9E6CDA)
                    )
                ),
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(
                        0xFF9E6CDA)),
                  ),
                  onPressed: (){
                    if(_authData.isPicAvail==true){
                      if(_formKey.currentState!.validate()){
                        setState(() {
                          _isLoading = true;
                        });
                        _authData.registerVendor(email, password).then((credential){
                          if(credential?.user?.uid!=null){
                            uploadFile(_authData.image.path).then((url){
                              if(url!=null){
                                // save vendor details to db
                                _authData.saveVendorDataToDb(
                                  url: url,
                                  mobile: mobile,
                                  shopName: shopName,
                                  dialog: _dialogTextController.text,

                                );
                                setState(() {
                                  _formKey.currentState?.reset();
                                  _isLoading = false;
                                });
                                Navigator.pushReplacementNamed(context, HomeScreen.id);

                                Navigator.pushReplacementNamed(context, HomeScreen.id);
                              }else{
                                scaffoldMessage('Upload Fail');
                              }
                            });
                          }else{
                            scaffoldMessage(_authData.error);
                          }
                        });
                      }
                    }else{
                      scaffoldMessage('Shop Profile Image need to be Added.');
                    }
                  },
                  child: Text('Register', style: TextStyle(color: Color(
                      0xFFFFFFFF)),),
                ),
              ),
            ],
          )
        ],
      ),

    );
  }
}