import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shoppingmall/screens/home_screen.dart';
import 'package:shoppingmall/services/user_services.dart';

class AuthProvider with ChangeNotifier{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String smsOtp;
  late String verificationId;
  String error = '';
  UserServices _userServices = UserServices();
  bool loading = false;
  late File image;
  bool isPicAvail = false;
  String pickerError = '';
  late double shopLatitude;
  late double shopLongitude;
  late String shopAddress;
  late String email;
  late String address;

  Future<void>verifyPhone(BuildContext context, String number)async {

    this.loading = true;
    notifyListeners();

    final PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential credential)async{
      this.loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed = (FirebaseAuthException e){
      this.loading=false;
      print(e.code);
      this.error = e.toString();
      notifyListeners();
    };

    final PhoneCodeSent smsOtpSend = (String verId, int? resendToken) async {
      this.verificationId = verId;

      // Dialog to enter OTP SMS
      smsOtpDialog(context, number); // await the dialog

      // Handle OTP verification and sign-in here
    };


    try{

      _auth.verifyPhoneNumber(

          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String verId){
            this.verificationId = verId;
          });

    }catch(e){
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
  }

  Future<Future>smsOtpDialog(BuildContext context,String number) async {
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Column(
              children: [
                Text('Verification Code'),
                SizedBox(height: 6,),
                Text('Enter 6-digits OTP received as SMS',
                  style: TextStyle(color: Colors.grey,
                      fontSize: 12),),
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value){
                  this.smsOtp = value;
                },
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  try{
                    PhoneAuthCredential phoneAuthCredential =
                    PhoneAuthProvider.credential(
                        verificationId: verificationId, smsCode: smsOtp);

                    final User? user = (await _auth.signInWithCredential(phoneAuthCredential)).user;

                    //create user data in firestore after user successfully registered

                    _createUser(id: user?.uid, number: user?.phoneNumber);

                    // navigate to Home page after login
                    if(user!=null){
                      Navigator.of(context).pop();


                      Navigator.pushReplacementNamed(context, HomeScreen.id);

                    }else{
                      print('Login Failed');
                    }

                  }catch(e){
                    this.error = 'Invalid OTP';
                    notifyListeners();
                    print(e.toString());
                    Navigator.of(context).pop();
                  }
                },
                child: Text('DONE'),
              ),
            ],
          );
        });
  }

//reduce image size
  Future<File> getImage() async {

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 20); // Use pickImage instead of getImage

    if (pickedFile != null) {
      this.image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickerError='Image not Selected';
      print('Image not selected.');
      notifyListeners();
    }
    return this.image;
  }

  Future getCurrentAddress()async{
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    this.shopLatitude = _locationData.latitude!;
    this.shopLongitude = _locationData.longitude!;
    notifyListeners();


  }

  Future<UserCredential?> registerVendor(String email, String password) async {
    this.email = email;
    notifyListeners();
    UserCredential? userCredential; // Make it nullable

    try {
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error = 'The password provided is too weak.';
        notifyListeners();
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        this.error = 'The account already exists for that email.';
        notifyListeners();
        print('The account already exists for that email.');
      }
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

  // login
  Future<UserCredential?> loginVendor(String email, String password) async {
    this.email = email;
    notifyListeners();
    UserCredential? userCredential; // Make it nullable

    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      this.error=e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

  // reset password
  Future<UserCredential?> resetPassword(String email) async {
    this.email = email;
    notifyListeners();
    UserCredential? userCredential; // Make it nullable

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      this.error=e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

  // save vendor data to Firestore

  Future<void> saveVendorDataToDb({
    String? url, String? shopName, String? mobile, String? dialog})async {

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentReference _vendors = FirebaseFirestore.instance.collection('vendors').doc(user.uid);
      _vendors.set({
        'uid': user.uid,
        'shopName': shopName,
        'mobile': mobile,
        'email': this.email,
        'dialog': dialog,
        'shopOpen': true,
        'rating':0.00,
        'totalRating': 0,
        'isTopPicked': false, //keep initial value as false
        'imageUrl':url,
        'accVerified' :false //keep initial value as false
      });
    } else {
      // Handle the case where 'user' is null, perhaps by showing an error message or taking appropriate action.
      return null;
    }


  }


  void _createUser({String? id, String? number}){
    _userServices.createUserData({
      'id':id,
      'number':number,
    });
    this.loading=false;
    notifyListeners();
  }

  void updateUser(
      {String? id, String? number,}){
    _userServices.updateUserData({
      'id':id,
      'number':number,
    });
    this.loading=false;
    notifyListeners();
  }

}