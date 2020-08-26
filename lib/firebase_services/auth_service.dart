import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:heard/home/navigation.dart';
import 'package:heard/http_services/sli_services.dart';
import 'package:heard/http_services/user_services.dart';
import 'package:heard/landing/landing_page.dart';
import 'package:heard/landing/user_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  //Sign out
  signOut(BuildContext context) async {
    await _auth.signOut();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    print('preference now isSLI after logout: ${preferences.containsKey('isSLI')}');
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LandingPage()),
    );
  }

  //Sign out and Delete existing account
  deleteAndSignOut({BuildContext context}) async {
    auth.User currentUser = _auth.currentUser;
    if (currentUser != null) {
      String authTokenString = await currentUser.getIdToken();

      // delete user from database
      SharedPreferences preferences = await SharedPreferences.getInstance();
      if (preferences.getBool('isSLI') == false)
        await UserServices().deleteUser(headerToken: authTokenString, phoneNumber: currentUser.phoneNumber);
      else
        await SLIServices().deleteSLI(headerToken: authTokenString, phoneNumber: currentUser.phoneNumber);
    }
    signOut(context);
  }

  //SignIn
  signIn(BuildContext context, auth.AuthCredential authCreds) {
    _auth.signInWithCredential(authCreds).catchError((error) {
      print("Error caught signing in");
    }).then((user) {
      user.user.getIdToken().then((tokenResult) {
        print('IDDD: $tokenResult');
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
          MaterialPageRoute(builder: (context) => LandingPage()),
        );
      }
    });
  }

  signInWithOTP(
      {BuildContext context,
      UserDetails userDetails,
      String smsCode,
      String verId}) async {
    try {
      auth.AuthCredential authCreds = auth.PhoneAuthProvider.credential(
          verificationId: verId, smsCode: smsCode);

      // getting auth result after signing in with credentials
      auth.UserCredential authResult =
          await _auth.signInWithCredential(authCreds).catchError((error) {
        print("Error caught signing in");
      });

      // getting the authentication token from current firebase user state
      String authTokenString =
          await authResult.user.getIdToken();


      if (authResult.user != null) {
        if (userDetails.isSLI == false) {
          bool userExists = await UserServices().doesUserExist(headerToken: authTokenString);
          if (userExists == false) {
            await UserServices().createUser(
              headerToken: authTokenString,
              name: userDetails.fullName.text,
              phoneNumber: userDetails.phoneNumber.text,
            );
          }
        } else {
          bool sliExists = await SLIServices().doesSLIExist(headerToken: authTokenString);
          if (sliExists == false) {
            await SLIServices().createSLI(
              headerToken: authTokenString,
              sliDetails: userDetails,
            );
          }
        }

        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Navigation(isSLI: userDetails.isSLI)),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LandingPage()),
        );
      }
    } catch (e) {
      debugPrint("Error on Sign-in");
    }
  }

  static Future<String> getToken() async {
    auth.User user = auth.FirebaseAuth.instance.currentUser;
    String token = await user.getIdToken();
    return token;
  }
}
