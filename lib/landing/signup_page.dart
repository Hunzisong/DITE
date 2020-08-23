import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/landing/user_details.dart';
import 'package:heard/landing/verification_page.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignUpPage extends StatefulWidget {
  final bool isSLI;
  SignUpPage({this.isSLI = false});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool showLoadingAnimation = false;
  String verificationId;
  bool codeSent = false;
  UserDetails userDetails;

  @override
  void initState() {
    super.initState();
    userDetails = UserDetails();
    userDetails.setUserType(isSLI: widget.isSLI);
  }

  @override
  void dispose() {
    super.dispose();
    userDetails.disposeTexts();
    print('Disposed text editor');
  }

//  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    bool isSLI = widget.isSLI;
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: showLoadingAnimation,
        child: Scaffold(
//        key: globalKey,
          appBar: AppBar(
            backgroundColor: Colours.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              isSLI ? 'Pendaftaran JBIM' : 'Pendaftaran',
              style: TextStyle(
                  fontSize: FontSizes.mainTitle,
                  fontWeight: FontWeight.bold,
                  color: Colours.black),
            ),
            centerTitle: true,
            elevation: 0.0,
          ),
          backgroundColor: Colours.white,
          body: ListView(
            children: <Widget>[
              Padding(
                padding: Paddings.signUpPage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InputField(
                      controller: userDetails.fullName,
                      labelText: 'Nama Penuh',
                    ),
                    InputField(
                      hintText: '+60123456789',
                      controller: userDetails.phoneNumber,
                      labelText: 'Nombor Telefon',
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: Dimensions.d_15),
                    isSLI
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: Paddings.vertical_5,
                                child: Text(
                                  'Jantina',
                                  style: TextStyle(
                                      fontSize: FontSizes.normal,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: RadioListTile(
                                        dense: true,
                                        title: Text(
                                          'Lelaki',
                                          style: TextStyle(
                                              fontSize: FontSizes.smallerText),
                                        ),
                                        value: Gender.male,
                                        groupValue: userDetails.gender,
                                        onChanged: (Gender value) {
                                          setState(() {
                                            userDetails.gender = value;
                                          });
                                        }),
                                  ),
                                  Expanded(
                                    child: RadioListTile(
                                        dense: true,
                                        title: Text(
                                          'Perempuan',
                                          style: TextStyle(
                                              fontSize: FontSizes.smallerText),
                                        ),
                                        value: Gender.female,
                                        groupValue: userDetails.gender,
                                        onChanged: (Gender value) {
                                          setState(() {
                                            userDetails.gender = value;
                                          });
                                        }),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Dimensions.d_15,
                              ),
                              CheckBoxTile(
                                value: userDetails.hasExperience,
                                onChanged: (bool value) {
                                  setState(() {
                                    userDetails.hasExperience = value;
                                  });
                                },
                                text:
                                    'Saya berpengalaman dalam bidang perubatan﻿',
                              ),
                              CheckBoxTile(
                                value: userDetails.isFluent,
                                onChanged: (bool value) {
                                  setState(() {
                                    userDetails.isFluent = value;
                                  });
                                },
                                text: 'Saya fasih berbahasa Isyarat Malaysia',
                              ),
                            ],
                          )
                        : SizedBox(height: 0),
                    CheckBoxTile(
                      value: userDetails.termsAndConditions,
                      onChanged: (bool value) {
                        setState(() {
                          userDetails.termsAndConditions = value;
                        });
                      },
                      text: 'Saya bersetuju dengan ',
                      textLink: 'Terma dan Syarat'
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: UserButton(
            text: 'Daftar Sekarang',
            color: isSLI ? Colours.orange : Colours.blue,
            padding: EdgeInsets.all(Dimensions.d_30),
            onClick: () {
              if (allFieldsFilled(isSLI) == false) {
                popUpDialog(
                    context: context,
                    isSLI: isSLI,
                    header: 'Amaran',
                    content: Padding(
                      padding: EdgeInsets.symmetric(vertical: Dimensions.d_45),
                      child: Text(
                        'Sila isi bidang yang kosong dahulu',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colours.darkGrey,
                            fontSize: FontSizes.normal),
                      ),
                    ),
                    onClick: () {
                      Navigator.pop(context);
                    });
              } else if (userDetails.termsAndConditions == false) {
                popUpDialog(
                    context: context,
                    isSLI: isSLI,
                    header: 'Amaran',
                    content: Padding(
                      padding: EdgeInsets.symmetric(vertical: Dimensions.d_45),
                      child: Text(
                        'Sila setuju dengan terma dan syarat dahulu',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colours.darkGrey,
                            fontSize: FontSizes.normal),
                      ),
                    ),
                    onClick: () {
                      Navigator.pop(context);
                    });
//              final termsConditionsSnackBar = SnackBar(
//                  content: Text('Sila setuju dengan terma dan syarat dahulu'));
//              globalKey.currentState.showSnackBar(termsConditionsSnackBar);
              } else {
                setState(() {
                  showLoadingAnimation = true;
                });
                verifyPhone(userDetails.phoneNumber.text);
              }
            },
          ),
        ),
      ),
    );
  }

  bool allFieldsFilled(bool isSLI) {
    return !isSLI
        ? userDetails.phoneNumber.text.isNotEmpty &&
            userDetails.fullName.text.isNotEmpty
        : userDetails.phoneNumber.text.isNotEmpty &&
            userDetails.fullName.text.isNotEmpty &&
        userDetails.gender != null;
  }

//  Future<void> createNewUser(
//      {bool isSLI,
//      TextFieldMap textInput,
//      CheckBoxMap checkInput,
//      gender gender}) async {
//    if (!isSLI) {
//      print('auth token: ${AuthService.authToken}');
//      var response = await http.post(
//          'https://heard-project.herokuapp.com/user/create',
//          headers: {
//            'Authorization': AuthService.authToken,
//          },
//          body: {
//            'name': textInput.fullName.text,
//            'phone_no': textInput.phoneNumber.text,
//            'profile_pic': 'test1'
//          });
//      print('response ${response.statusCode}');
//      print('response ${response.body}');
//    }
//  }

  void pushVerificationPage() {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                VerificationPage(verificationId: this.verificationId, userDetails: this.userDetails)));
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) async {
      print('first line');
//      AuthService().signIn(context, authResult);
      print('after');
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      debugPrint('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
        popUpDialog(
          context: context,
          isSLI: widget.isSLI,
          touchToDismiss: false,
          header: 'Pengesahan',
          content: Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.d_45),
            child: Text(
              'Daftar berjaya! Sila klik Teruskan untuk menyerus ke halaman pengesahan.',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colours.darkGrey,
                  fontSize: FontSizes.normal),
            ),
          ),
          buttonText: 'Teruskan',
          onClick: () {
            pushVerificationPage();
          }
        );
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
