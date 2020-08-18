import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heard/api/user_exists.dart';
import 'package:heard/home/navigation.dart';
import 'package:heard/startup/signup_page.dart';
import 'package:heard/startup/startup_page.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Sign out
  signOut(BuildContext context) async {
    _auth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StartupPage()),
    );
  }

  //Sign out and Delete existing account
  deleteAndSignOut(BuildContext context) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    if (currentUser != null) {
      IdTokenResult token = await currentUser.getIdToken(refresh: false);
      String authTokenString = token.token.toString();
      print('phone: ${currentUser.phoneNumber}');
      var response = await http
          .post('https://heard-project.herokuapp.com/user/delete', headers: {
        'Authorization': authTokenString,
      }, body: {
        'phone': currentUser.phoneNumber
      });
      print('Delete User response: ${response.statusCode}, body: ${response.body}');
    }
    signOut(context);
  }

  //SignIn
  signIn(BuildContext context, AuthCredential authCreds) {
    _auth.signInWithCredential(authCreds).catchError((error) {
      print("Error caught signing in");
    }).then((user) {
      user.user.getIdToken(refresh: false).then((tokenResult) {
        print('IDDD: ${tokenResult.token.toString()}');
//        authToken = tokenResult.token.toString();
      });
      if (user != null) {
        Navigator.pop(context);
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

  signInWithOTP(
      {BuildContext context,
      TextFieldMap userDetails,
      String smsCode,
      String verId}) async {
    try {
      AuthCredential authCreds = PhoneAuthProvider.getCredential(
          verificationId: verId, smsCode: smsCode);

      // getting auth result after signing in with credentials
      AuthResult authResult =
          await _auth.signInWithCredential(authCreds).catchError((error) {
        print("Error caught signing in");
      });

      // getting the authentication token from current firebase user state
      IdTokenResult authToken =
          await authResult.user.getIdToken(refresh: false);

      String authTokenString = authToken.token.toString();
      print('Authentication Token: $authTokenString');

      var isNewUser = await http
          .get('https://heard-project.herokuapp.com/user/exists', headers: {
        'Authorization': authTokenString,
      });

      UserExists userExists = UserExists.fromJson(isNewUser.body);
      print('Does user exists: ${userExists.exists}');

      if (userExists.exists == false) {
        var response = await http
            .post('https://heard-project.herokuapp.com/user/create', headers: {
          'Authorization': authTokenString,
        }, body: {
          'name': userDetails.fullName.text,
          'phone_no': userDetails.phoneNumber.text,
          'profile_pic': 'test1'
        });
        print('Create User response: ${response.statusCode}, body: ${response.body}');
      } else {
        var response = await http
            .get('https://heard-project.herokuapp.com/user/me', headers: {
          'Authorization': authTokenString,
        });
        print('Get User response: ${response.statusCode}, body: ${response.body}');
      }

      if (authResult.user != null) {
        Navigator.pop(context);
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
    } catch (e) {
      debugPrint("Error on Signin");
    }
  }

  static Future<String> getToken() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    IdTokenResult token = await user.getIdToken(refresh: false);
    return token.token.toString();
  }
}
