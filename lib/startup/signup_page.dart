import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heard/services/auth_service.dart';
import 'package:heard/startup/verification_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  ///todo: change this variable to be more dynamic in the future
  ///change the variable to see difference between SLI and normal user.
  bool isSLI = true;
  String verificationId;
  bool codeSent = false;

  gender _gender;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colours.white,
          body: ListView(
            children: <Widget>[
              Padding(
                padding: Paddings.signUpPage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      isSLI ? 'Pendaftaran SLI' : 'Pendaftaran',
                      style: TextStyle(
                          fontSize: FontSizes.title,
                          fontWeight: FontWeight.bold),
                    ),
                    InputField(
                      controller: TextFieldMap.firstName,
                      labelText: 'Nama Pertama',
                    ),
                    InputField(
                      controller: TextFieldMap.lastName,
                      labelText: 'Nama Keluarga',
                    ),
                    InputField(
                      controller: TextFieldMap.phoneNumber,
                      labelText: 'Nombor Telefon',
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
                                        title: Text('Lelaki'),
                                        value: gender.male,
                                        groupValue: _gender,
                                        onChanged: (gender value) {
                                          setState(() {
                                            _gender = value;
                                          });
                                        }),
                                  ),
                                  Expanded(
                                    child: RadioListTile(
                                        title: Text('Perempuan'),
                                        value: gender.female,
                                        groupValue: _gender,
                                        onChanged: (gender value) {
                                          setState(() {
                                            _gender = value;
                                          });
                                        }),
                                  ),
                                ],
                              ),
                              CheckBoxTile(
                                value: CheckBoxMap.hasExperience,
                                onChanged: (bool value) {
                                  setState(() {
                                    CheckBoxMap.hasExperience = value;
                                  });
                                },
                                text: '\t\tSaya berpengalaman dalam bidang perubatan﻿',
                              ),
                              CheckBoxTile(
                                value: CheckBoxMap.isFluent,
                                onChanged: (bool value) {
                                  setState(() {
                                    CheckBoxMap.isFluent = value;
                                  });
                                },
                                text: '\t\tSaya fasih berbahasa Isyarat Malaysia',
                              ),
                            ],
                          )
                        : SizedBox(height: 0),
                    CheckBoxTile(
                      value: CheckBoxMap.termsAndConditions,
                      onChanged: (bool value) {
                        setState(() {
                          CheckBoxMap.termsAndConditions = value;
                          print(CheckBoxMap.termsAndConditions);
                        });
                      },
                      text: '\t\tSaya bersetuju dengan ',
                      textLink: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Terma dan Syarat',
                          style: TextStyle(
                              color: Colours.darkBlue,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              fontSize: FontSizes.smallerText),
                        ),
                      ),
                    ),
                    UserButton(
                      text: 'Daftar Sekarang',
                      color: Colours.blue,
                      onClick: () {
                        verifyPhone(TextFieldMap.phoneNumber.text);
                      },
                    ),
                  ],
                ),
              ),
            ],
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

class CheckBoxTile extends StatefulWidget {
  final bool value;
  final Function onChanged;
  final String text;
  final Widget textLink;

  CheckBoxTile({this.onChanged, this.value, this.text, this.textLink = const SizedBox(height: 0)});

  @override
  _CheckBoxTileState createState() => _CheckBoxTileState();
}

class _CheckBoxTileState extends State<CheckBoxTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.vertical_15,
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: widget.value,
              onChanged: widget.onChanged,
            ),
          ),
          Text(
            widget.text,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: FontSizes.smallerText),
          ),
          widget.textLink
        ],
      ),
    );
  }
}


class TextFieldMap {
  static TextEditingController firstName = TextEditingController();
  static TextEditingController lastName = TextEditingController();
  static TextEditingController phoneNumber = TextEditingController();
}

class CheckBoxMap {
  static bool hasExperience = false;
  static bool isFluent = false;
  static bool termsAndConditions = false;
}
