import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class CustomerMobileLogin extends StatefulWidget {
  //const CustomerMobileLogin({super.key});

  static const String id = 'customermobile-screen';

  @override
  _CustomerMobileLoginState createState() => _CustomerMobileLoginState();
}

class _CustomerMobileLoginState extends State<CustomerMobileLogin> {
  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);

    bool _validPhoneNumber = false;
    var _phoneNumberController = TextEditingController();

    void showBottomSheet(context){
      showModalBottomSheet(
        context: context,
        builder: (context)=> StatefulBuilder(
          builder: (context, StateSetter myState){
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: auth.error=='Invalid OTP'? true:false,
                      child: Container(
                        child: Column(
                          children: [
                            Text(auth.error,style: TextStyle(color: Colors.red, fontSize: 12),),
                            SizedBox(height: 5,),
                          ],
                        ),
                      ),
                    ),
                    Text('LOGIN', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                    Text('Enter Your Phone Number to Proceed', style: TextStyle(fontSize: 16, color: Colors.black38),),
                    SizedBox(height: 20,),
                    TextField(
                      decoration: InputDecoration(
                        prefixText: '+94',
                        labelText: '10-digits Mobile Number',
                      ),
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      maxLength: 9,
                      controller: _phoneNumberController,
                      onChanged: (value){
                        if(value.length==9){
                          myState((){
                            _validPhoneNumber = true;
                          });
                        }else{
                          myState((){
                            _validPhoneNumber = false;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AbsorbPointer(
                            absorbing: _validPhoneNumber ? false:true,
                            child: ElevatedButton(
                              onPressed: (){
                                myState((){
                                  auth.loading = true;
                                });
                                String number = '+94${_phoneNumberController
                                    .text}';
                                auth.verifyPhone(context, number).then((value){
                                  _phoneNumberController.clear();
                                  //auth.loading=false;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                              ),
                              child: auth.loading? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ): Text(_validPhoneNumber ? 'CONTINUE' : 'ENTER PHONE NUMBER', style: TextStyle(color: Colors.white,),),
                            ),
                          ),
                        ),],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/signup-page.png', // Replace with your image file path
              width: 300.0, // Set the width as needed
              height: 300.0, // Set the height as needed
            ),
            SizedBox(height: 20,),

            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
              ),
              child: RichText(
                text: TextSpan(
                  text: 'Already Registered ?',style: TextStyle(color: Colors.white70),
                  children: [
                    TextSpan(
                        text: ' Login', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
                    )
                  ],
                ),
              ),
              onPressed: (){
                showBottomSheet(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}