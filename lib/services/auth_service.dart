import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heard/home/navigation.dart';
import 'package:heard/startup/startup_page.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static String authToken;

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
      user.user.getIdToken(refresh: false).then((tokenResult) {
        print('IDDD2: ${tokenResult.token.toString()}');
        authToken = tokenResult.token.toString();
      });
      if (user != null) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Navigation()),
        );
      }
      else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StartupPage()),
        );
      }
    });
  }

  signInWithOTP(context, userDetails, smsCode, verId) {
    try {
      AuthCredential authCreds = PhoneAuthProvider.getCredential(
          verificationId: verId, smsCode: smsCode);
      _auth.signInWithCredential(authCreds)
          .catchError((error) {
        print("Error caught signing in");
      }).then((user) {
        user.user.getIdToken(refresh: false).then((tokenResult) async {
          print('IDDD2: ${tokenResult.token.toString()}');
          authToken = tokenResult.token.toString();
          await http.post(
              'https://heard-project.herokuapp.com/user/create',
              headers: {
                'Authorization': AuthService.authToken,
              },
              body: {
                'name': userDetails.fullName.text,
                'phone_no': userDetails.phoneNumber.text,
                'profile_pic': 'test1'
              });
        });
        if (user != null) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Navigation()),
          );
        }
        else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StartupPage()),
          );
        }
      });
    } catch (e) {
      debugPrint("Error on Signin");
    }
  }
}
