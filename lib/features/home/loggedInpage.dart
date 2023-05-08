// ignore_for_file: prefer_const_constructors, prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../styles/colors.dart';
import '../auth/user_auth.dart';
import 'home_page.dart';

class LoggedInWidget extends StatelessWidget{
  const LoggedInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: greenButtonColor,),);
            } else if(snapshot.hasData){
              return HomeScreen();
            }
            else if(snapshot.hasError){
              return Center(child: Text('Something Went Wrong'));
            }else{
              return UserAuthentication();
            }
          },
        )));
  }


}
