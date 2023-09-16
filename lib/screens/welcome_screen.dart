import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/auth_provider.dart';
import 'package:shoppingmall/providers/location_provider.dart';
import 'package:shoppingmall/screens/auth_screen.dart';
import 'package:shoppingmall/screens/map_screen.dart';
import 'package:shoppingmall/screens/onboarding_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import 'chat_bot_app.dart';

class WelcomeScreen extends StatefulWidget {
  //const WelcomeScreen({super.key});
  static const String id = 'welcome-screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
                      maxLength: 10,
                      controller: _phoneNumberController,
                      onChanged: (value){
                        if(value.length==10){
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
                                String number = '+91${_phoneNumberController
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

    final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Positioned(
              right: 0.0,
              top: 20.0,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFB598E3)),
                ),
                child: Text('SKIP', style: TextStyle(color: Color(0xFF0E0434)),),
                onPressed: (){

                },
              ),
            ),

            Column(
              children: [
                Expanded(child: OnBoardScreen(),),

                TextButton(
                  child: Text('Vendor', style: TextStyle(color: Color(0xFF0E0434)),),
                  onPressed: (){
                    Navigator.pushNamed(context, AuthScreen.id);
                  },
                ),
                TextButton(

                  child: Text('Shop Finder', style: TextStyle(color: Color(
                      0xFF36353D), fontSize: 15)),
                  onPressed: () async {
                    setState(() {
                      locationData.loading=true;
                    });

                    final locationStatus = await Permission.location.status;
                    if (locationStatus.isGranted) {
                      await locationData.getCurrentPosition();
                      if (locationData.permissionAllowed == true) {
                        Navigator.pushReplacementNamed(context, MapScreen.id);
                      } else {
                        print('Permission Not Allowed');
                      }
                    } else {
                      // Request location permission
                      final status = await Permission.location.request();
                      if (status.isGranted) {
                        await locationData.getCurrentPosition();
                        if (locationData.permissionAllowed == true) {
                          Navigator.pushReplacementNamed(context, MapScreen.id);
                        } else {
                          print('Permission Not Allowed');
                        }
                      } else {
                        print('Location permission denied');
                      }
                    }
                  },
                ),

                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFFB598E3)),
                  ),
                  child: Text('Give Your Feedback...', style: TextStyle(color: Colors.black),),
                  onPressed: (){
                    /*Navigator.push(
                      context,
                     /* MaterialPageRoute(
                        //builder: (context) => FeedbackScreen(),
                      ),*/
                    );*/
                  },
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
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the ChatbotApp when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatbotApp(),
            ),
          );
        },
        child: Icon(Icons.chat_bubble),
        backgroundColor: Colors.deepPurple, // Customize the button's color
      ),
    );
  }
<<<<<<< HEAD
}
=======
}

void main() {
  runApp(ChatbotApp());
}

class ChatbotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent), // Set your accent color
      ),
      home: ChatScreen(),
    );
  }
}

// Define your ChatScreen, AuthProvider, and other widgets here

>>>>>>> origin/master
