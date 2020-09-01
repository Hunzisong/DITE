import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/landing/user_details.dart';
import 'package:heard/landing/verification_page.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  bool showLoadingAnimation = false;
  String verificationId;
  bool codeSent = false;
  UserDetails userDetails;

  @override
  void initState() {
    super.initState();
    userDetails = UserDetails();
  }

  @override
  void dispose() {
    super.dispose();
    userDetails.disposeTexts();
    print('Disposed text editor in login page');
  }

  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colours.white,
            body: ModalProgressHUD(
              inAsyncCall: showLoadingAnimation,
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Padding(
                    padding: Paddings.startupMain,
                    child: Column(
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
                          hintText: '+60123456789',
                          controller: userDetails.phoneNumber,
                          labelText: 'Nombor Telefon',
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: Dimensions.d_15),
                        UserButton(
                          text: 'Log Masuk Sebagai Pengguna',
                          color: Colours.blue,
                          onClick: () async {
                            setState(() {
                              showLoadingAnimation = true;
                              userDetails.setUserType(isSLI: false);
                            });
                            await verifyPhone(userDetails.phoneNumber.text);
                          },
                        ),
                        UserButton(
                          text: 'Log Masuk Sebagai JBIM',
                          color: Colours.orange,
                          onClick: () async {
                            setState(() {
                              showLoadingAnimation = true;
                              userDetails.setUserType(isSLI: true);
                            });
                            await verifyPhone(userDetails.phoneNumber.text);
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
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void pushVerificationPage() {
    Navigator.pop(context);
    print('isSLI LOGIN: ${userDetails.isSLI}');
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            VerificationPage(verificationId: this.verificationId, userDetails: userDetails)
        ));
  }

  Future<void> verifyPhone(phoneNo) async {
    final auth.PhoneVerificationCompleted verified = (auth.AuthCredential authResult) {
//      AuthService().signIn(context, authResult);
    };

    final auth.PhoneVerificationFailed verificationFailed =
        (auth.FirebaseAuthException authException) {
      debugPrint('${authException.message}');
    };

    final auth.PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
      pushVerificationPage();
    };

    final auth.PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    await auth.FirebaseAuth.instance.verifyPhoneNumber (
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout
    );
  }
}
