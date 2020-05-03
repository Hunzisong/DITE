import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/home/navigation.dart';
import 'package:heard/startup/verification_page.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:heard/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  TextEditingController phoneNumberText = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  String verificationId;
  bool codeSent = false;

  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
          backgroundColor: Colours.white,
          body: Padding(
            padding: Paddings.startupMain,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: Dimensions.d_140,
                      child: Hero(
                        tag: 'appLogo',
                        child: Image(
                          image: AssetImage('images/diteLogo.png'),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.d_30),
                    InputField(
                      controller: phoneNumberText,
                      labelText: 'Nombor Telefon',
                    ),
                    InputField(
                      controller: passwordText,
                      labelText: 'Kata Laluan',
                      isPassword: true,
                    ),
                    SizedBox(height: Dimensions.d_15),
                    UserButton(
                      text: 'Log Masuk Sebagai Pengguna',
                      color: Colours.grey,
                      onClick: () {
                        verifyPhone(phoneNumberText.text);
                        //phoneNumberText.dispose();
                        //passwordText.dispose();
                      },
                    ),
                    UserButton(
                      text: 'Log Masuk Sebagai BIM',
                      color: Colours.lightBlue,
                      onClick: () {
                        /// EXAMPLE: How to obtain the text from text field to use for verification
                        print('phone number: ${phoneNumberText.text}\npassword: ${passwordText.text}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Navigation()),
                        );
                        //phoneNumberText.dispose();
                        //passwordText.dispose();
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: Paddings.vertical_15,
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Saya terlupa kata laluan',
                          style: TextStyle(
                              color: Colours.darkBlue,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              fontSize: FontSizes.smallerText),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(context, authResult);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      debugPrint('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    FirebaseAuth.instance.verifyPhoneNumber (
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout
    );

    if(codeSent) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              VerificationPage(verificationId: this.verificationId)
          ));
    }
  }
}
