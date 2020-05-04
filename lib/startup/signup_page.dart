import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heard/services/auth_service.dart';
import 'package:heard/startup/verification_page.dart';

class SignUpPage extends StatefulWidget {
  final bool isSLI;
  SignUpPage({this.isSLI = false});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String verificationId;
  bool codeSent = false;
  TextFieldMap textFieldMap;
  CheckBoxMap checkBoxMap;

  gender _gender;

  @override
  void initState() {
    super.initState();
    textFieldMap = TextFieldMap();
    checkBoxMap = CheckBoxMap();
  }

  @override
  void dispose() {
    super.dispose();
    textFieldMap.disposeTexts();
  }

  @override
  Widget build(BuildContext context) {
    bool isSLI = widget.isSLI;
    return SafeArea(
      child: Scaffold(
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
                  fontSize: FontSizes.title, fontWeight: FontWeight.bold, color: Colours.black),
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
                      controller: textFieldMap.firstName,
                      labelText: 'Nama Pertama',
                    ),
                    InputField(
                      controller: textFieldMap.lastName,
                      labelText: 'Nama Keluarga',
                    ),
                    InputField(
                      controller: textFieldMap.phoneNumber,
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
                                value: checkBoxMap.hasExperience,
                                onChanged: (bool value) {
                                  setState(() {
                                    checkBoxMap.hasExperience = value;
                                  });
                                },
                                text:
                                    '\t\tSaya berpengalaman dalam bidang perubatan﻿',
                              ),
                              CheckBoxTile(
                                value: checkBoxMap.isFluent,
                                onChanged: (bool value) {
                                  setState(() {
                                    checkBoxMap.isFluent = value;
                                  });
                                },
                                text:
                                    '\t\tSaya fasih berbahasa Isyarat Malaysia',
                              ),
                            ],
                          )
                        : SizedBox(height: 0),
                    CheckBoxTile(
                      value: checkBoxMap.termsAndConditions,
                      onChanged: (bool value) {
                        setState(() {
                          checkBoxMap.termsAndConditions = value;
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
                        verifyPhone(textFieldMap.phoneNumber.text);
                      },
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  void pushVerificationPage() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            VerificationPage(verificationId: this.verificationId)
        ));
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
      pushVerificationPage();
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

class CheckBoxTile extends StatefulWidget {
  final bool value;
  final Function onChanged;
  final String text;
  final Widget textLink;

  CheckBoxTile(
      {this.onChanged,
      this.value,
      this.text,
      this.textLink = const SizedBox(height: 0)});

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
                fontWeight: FontWeight.w600, fontSize: FontSizes.smallerText),
          ),
          widget.textLink
        ],
      ),
    );
  }
}

class TextFieldMap {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  void disposeTexts() {
    firstName.dispose();
    lastName.dispose();
    phoneNumber.dispose();
  }
}

class CheckBoxMap {
  bool hasExperience = false;
  bool isFluent = false;
  bool termsAndConditions = false;
}
