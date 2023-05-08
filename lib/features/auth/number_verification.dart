// ignore_for_file: library_private_types_in_public_api, unnecessary_new, prefer_const_constructors, sort_child_properties_last, depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../../styles/colors.dart';
import '../../styles/textstyles.dart';
import '../home/home_page.dart';

class NumberVerification extends StatefulWidget {
  @override
  _NumberVerificationState createState() => _NumberVerificationState();
}

class _NumberVerificationState extends State<NumberVerification> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? phoneNumber, verificationId;
  String? otp, authStatus = "";

  Future<void> verifyPhoneNumber(BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) {
        setState(() {
          authStatus = "Your account is successfully verified";
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>  HomeScreen(),
          ),);
      },
      verificationFailed: (FirebaseAuthException authException) {
        setState(() {
          authStatus = "Authentication failed";
        });
      },
      codeSent: (String? verId, [int? forceCodeResent]) {
        verificationId = verId;
        setState(() {
          authStatus = "OTP has been successfully send";
        });
        otpDialogBox(context).then((value) {});
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
        setState(() {
          authStatus = "TIMEOUT";
        });
      },
    );
  }

  otpDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter your OTP'),
            content: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                ),
                onChanged: (value) {
                  otp = value;
                  print(otp);
                },
              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  signIn(otp!);
                },
                child: Text(
                  'Submit',
                ),
              ),
            ],
          );
        });
  }

  Future<void> signIn(String otp) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: otp,
    );
    UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);

    User? user = result.user;
    if(user != null){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => HomeScreen()
      ));
    }else{
      print("Error");
    }
    // notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 1,
        iconTheme: const IconThemeData(
          size: 25, //change size on your need
          color: drawerColor, //change color on your need
        ),
        centerTitle: true,
        title: Text(
          'Number Verification',
          style: appBarText,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsLUEbKM3sDauW8uCiavv-eumz4gpkBpoviw&usqp=CAU",
              height: 100,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.phone,
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20),
                      ),
                    ),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.phone_iphone,
                      color: Colors.cyan,
                    ),
                    hintStyle: unSeletedDishCategoryText,
                    hintText: "Enter Your Phone Number...",
                    fillColor: Colors.white70),
                onChanged: (value) {
                  phoneNumber = value;
                },
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: 200,
              height: 40,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13)),
                  backgroundColor: greenLeftDrawerColor,
                ),
                onPressed: () {
                  phoneNumber == null ? null : verifyPhoneNumber(context);
                  // authStatus == "Your account is successfully verified"
                  //     ? HomeScreen()
                  //     : dispose;
                },
                child: Text(
                  "Verify Your Number",
                  style: btnTextStyle,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Please enter the phone number followed by country code",
              style: failureText,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              authStatus == "" ? "" : authStatus!,
              style: TextStyle(
                  color: authStatus!.contains("fail") ||
                          authStatus!.contains("TIMEOUT")
                      ? Colors.red
                      : Colors.green),
            )
          ],
        ),
      ),
    );
  }
}
