import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/auth_provider.dart';
import 'package:shoppingmall/screens/home_screen.dart';
import 'package:shoppingmall/widgets/reset_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String id = 'signin-screen';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  late Icon icon;
  bool _visible = false;
  var _emailTextController = TextEditingController();
  late String email;
  late String password;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'LOGIN',
                        style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Color(
                            0xFF914ADA)),
                      ),
                      SizedBox(height: 20,),
                      Image.asset(
                        'assets/images/signup-page.png',
                        height: 300.0,
                        width: 300.0,
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: _emailTextController,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter E-mail';
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
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF9E6CDA), width: 2),
                          ),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Enter Your E-mail',
                          prefixIcon: Icon(Icons.email, color: Color(0xFF9E6CDA)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF9E6CDA), width: 2),
                          ),
                          focusColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter Password';
                          }
                          if(value.length<6){
                            return 'Minimum 6-characters required.';
                          }
                          setState(() {
                            password=value;
                          });
                          return null;
                        },
                        obscureText: _visible == false ? true : false,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: _visible ? Icon(Icons.visibility, color: Color(0xFF9E6CDA)) : Icon(Icons.visibility_off, color: Color(0xFF9E6CDA)),
                            onPressed: () {
                              setState(() {
                                _visible=!_visible;
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF9E6CDA), width: 2),
                          ),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Enter Your Password',
                          prefixIcon: Icon(Icons.vpn_key, color: Color(0xFF9E6CDA)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF9E6CDA), width: 2),
                          ),
                          focusColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, ResetPassword.id );
                            },
                            child: Text(
                              'Forgot Password ?',
                              textAlign: TextAlign.end,
                              style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Color(
                                      0xFF914ADA)),
                                ),
                                onPressed: (){
                                  if(_formKey.currentState!.validate()){
                                    setState(() {
                                      _loading = true;
                                    });
                                    _authData.loginVendor(email, password).then((credential){
                                      if(credential!=null){

                                        setState(() {
                                          _loading = false;
                                        });

                                        Navigator.pushReplacementNamed(context, HomeScreen.id);
                                      }else{
                                        setState(() {
                                          _loading = false;
                                        });
                                        ScaffoldMessenger
                                            .of(context)
                                            .showSnackBar(SnackBar(content: Text(_authData.error)));
                                      }
                                    });
                                  }
                                },
                                child: _loading ? LinearProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  backgroundColor: Colors.transparent,
                                ) : Text('Login', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }
}