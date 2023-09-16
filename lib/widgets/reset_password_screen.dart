import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/auth_provider.dart';
import 'package:shoppingmall/screens/signin_screen.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  static const String id = 'reset-screen';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  late String email;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final _authData =  Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/reset.png'),
                  SizedBox(height: 20,),
                  RichText(text: TextSpan(
                      text: '',
                      children: [
                        TextSpan(text: 'Forgot Password ',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple, fontSize: 17)),
                        TextSpan(text: 'Please enter the email address you used to create your account and we will send you an email to reset your password.', style: TextStyle(color: Colors.purple, fontSize: 15)),
                      ]
                  ),),
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
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (){
                            if(_formKey.currentState!.validate()){
                              setState(() {
                                _loading = true;
                              });
                              _authData.resetPassword(email);
                              ScaffoldMessenger
                                  .of(context)
                                  .showSnackBar(SnackBar(content: Text('Check your Email ${_emailTextController.text} for reset password.')));
                            }
                            Navigator.pushReplacementNamed(context, SignInScreen.id);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(
                                0xFF914ADA)),
                          ),
                          child: _loading ? LinearProgressIndicator() : Text('Reset Password',style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}