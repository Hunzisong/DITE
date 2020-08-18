import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heard/home/navigation.dart';
import 'package:heard/http_services/sli_services.dart';
import 'package:heard/http_services/user_services.dart';
import 'package:heard/startup/startup_page.dart';
import 'package:heard/startup/user_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Sign out
  signOut(BuildContext context) async {
    _auth.signOut();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    print('preference now isSLI after logout: ${preferences.containsKey('isSLI')}');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StartupPage()),
    );
  }

  //Sign out and Delete existing account
  deleteAndSignOut({BuildContext context}) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    if (currentUser != null) {
      IdTokenResult token = await currentUser.getIdToken(refresh: false);
      String authTokenString = token.token.toString();

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
  signIn(BuildContext context, AuthCredential authCreds) {
    _auth.signInWithCredential(authCreds).catchError((error) {
      print("Error caught signing in");
    }).then((user) {
      user.user.getIdToken(refresh: false).then((tokenResult) {
        print('IDDD: ${tokenResult.token.toString()}');
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
      UserDetails userDetails,
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
          print("Existence: $sliExists \n ---------------------------");
          if (sliExists == false) {
            print("Creating SLI \n ----------------------");
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
          MaterialPageRoute(builder: (context) => StartupPage()),
        );
      }
    } catch (e) {
      debugPrint("Error on Sign-in");
    }
  }

  static Future<String> getToken() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    IdTokenResult token = await user.getIdToken(refresh: false);
    return token.token.toString();
  }
}
