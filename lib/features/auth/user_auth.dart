import 'package:flutter/material.dart';
import 'package:restaurant/provider/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../styles/colors.dart';
import '../../widgets/green_button.dart';
import 'number_verification.dart';

class UserAuthentication extends StatefulWidget {
  const UserAuthentication({Key? key}) : super(key: key);

  @override
  State<UserAuthentication> createState() => _UserAuthenticationState();
}

class _UserAuthenticationState extends State<UserAuthentication> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.network(
                'https://miro.medium.com/max/300/1*R4c8lHBHuH5qyqOtZb3h-w.png',
                height: 300,
                width: 150,
              ),
            ),
            const SizedBox(height: 50,),
            customButton(
                context,
                'Google',
                false,
                'https://icons-for-free.com/download-icon-Google-1320568266385361674_512.png',
                onGoogleSignIn,
                blueButtonColor),
            SizedBox(height:8),
            customButton(
                context,
                'Phone',
                true,
                Icons.phone,
                onVerifyingNumber,
                greenButtonColor)
          ],
        ),
      ),
    ));
  }
    onVerifyingNumber(){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>  NumberVerification(),
        ),);
    }
onGoogleSignIn(){
    final provider = Provider.of<GoogleSignInProvider>(context,listen:false);
    provider.googleLogin();
}
}
