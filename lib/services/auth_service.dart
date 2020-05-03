import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heard/home/navigation.dart';
import 'package:heard/startup/startup_page.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Sign out
  signOut(BuildContext context) {
    _auth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StartupPage()),
    );
  }

  //SignIn
  signIn(BuildContext context, AuthCredential authCreds) {
    _auth.signInWithCredential(authCreds)
        .catchError((error) {
      print("Error caught signing in");
    }).then((user) {
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Navigation()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StartupPage()),
        );
      }
    });
  }

  signInWithOTP(context, smsCode, verId) {
    try {
      AuthCredential authCreds = PhoneAuthProvider.getCredential(
          verificationId: verId, smsCode: smsCode);
      signIn(context, authCreds);
    } catch (e) {
      debugPrint("Error on Signin");
    }
  }
}
