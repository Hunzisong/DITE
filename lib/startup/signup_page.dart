import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heard/services/auth_service.dart';
import 'package:heard/startup/verification_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

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

  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    bool isSLI = widget.isSLI;
    return SafeArea(
      child: Scaffold(
        key: globalKey,
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
                    controller: textFieldMap.fullName,
                    labelText: 'Nama Penuh',
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
                                      dense: true,
                                      title: Text(
                                        'Lelaki',
                                        style: TextStyle(
                                            fontSize: FontSizes.smallerText),
                                      ),
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
                                      dense: true,
                                      title: Text(
                                        'Perempuan',
                                        style: TextStyle(
                                            fontSize: FontSizes.smallerText),
                                      ),
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
                            SizedBox(
                              height: Dimensions.d_15,
                            ),
                            CheckBoxTile(
                              value: checkBoxMap.hasExperience,
                              onChanged: (bool value) {
                                setState(() {
                                  checkBoxMap.hasExperience = value;
                                });
                              },
                              text:
                                  'Saya berpengalaman dalam bidang perubatan﻿',
                            ),
                            CheckBoxTile(
                              value: checkBoxMap.isFluent,
                              onChanged: (bool value) {
                                setState(() {
                                  checkBoxMap.isFluent = value;
                                });
                              },
                              text: 'Saya fasih berbahasa Isyarat Malaysia',
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
              final termsConditionsSnackBar =
                  SnackBar(content: Text('Sila isi bidang yang kosong dahulu'));
              globalKey.currentState.showSnackBar(termsConditionsSnackBar);
            } else if (checkBoxMap.termsAndConditions == false) {
              final termsConditionsSnackBar = SnackBar(
                  content: Text('Sila setuju dengan terma dan syarat dahulu'));
              globalKey.currentState.showSnackBar(termsConditionsSnackBar);
            } else {
              createDialog(
                  context: context,
                  isSLI:
                      isSLI); // Dialog for confirmation, and navigate to verification page
              verifyPhone(textFieldMap.phoneNumber.text);
              createNewUser(
                  isSLI: isSLI,
                  textInput: textFieldMap,
                  checkInput: checkBoxMap,
                  gender: _gender);
            }
          },
        ),
      ),
    );
  }

  bool allFieldsFilled(bool isSLI) {
    return !isSLI
        ? textFieldMap.phoneNumber.text.isNotEmpty &&
            textFieldMap.fullName.text.isNotEmpty
        : textFieldMap.phoneNumber.text.isNotEmpty &&
            textFieldMap.fullName.text.isNotEmpty &&
            _gender != null;
  }

  Future<void> createNewUser(
      {bool isSLI,
      TextFieldMap textInput,
      CheckBoxMap checkInput,
      gender gender}) async {
    if (!isSLI) {
//      var response = await http.post(
//          'https://virtserver.swaggerhub.com/dite/heard/1.0.0/user/create',
//          body: {
//            'Authorization': 'test1',
//            'first_name': textInput.firstName.text,
//            'last_name': textInput.lastName.text,
//            'phone_no': textInput.phoneNumber.text,
//            'profile_pic': 'test1'
//          });
//      print('response ${response.statusCode}');
    }
  }

  void pushVerificationPage() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                VerificationPage(verificationId: this.verificationId)));
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
  final String textLink;
  final String textLinkURL;

  CheckBoxTile(
      {this.onChanged,
      this.value,
      this.text,
      this.textLink,
      this.textLinkURL});

  @override
  _CheckBoxTileState createState() => _CheckBoxTileState();
}

class _CheckBoxTileState extends State<CheckBoxTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(Dimensions.d_0),
      leading: SizedBox(
        height: Dimensions.checkBoxSize,
        width: Dimensions.checkBoxSize,
        child: Checkbox(
          value: widget.value,
          onChanged: widget.onChanged,
        ),
      ),
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: widget.text,
              style: TextStyle(
                color: Colours.darkGrey,
                  fontWeight: FontWeight.w600, fontSize: FontSizes.smallerText),
            ),
            TextSpan(
              text: widget.textLink,
              style: TextStyle(
                  color: Colours.darkBlue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  fontSize: FontSizes.smallerText),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                /// todo: add url link for terms and conditions
//                  launch(widget.textLinkURL);
                },
            )
          ]
        ),
      ),
    );
  }
}

class TextFieldMap {
  TextEditingController fullName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  void disposeTexts() {
    fullName.dispose();
    phoneNumber.dispose();
  }
}

class CheckBoxMap {
  bool hasExperience = false;
  bool isFluent = false;
  bool termsAndConditions = false;
}

createDialog({BuildContext context, bool isSLI}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: Container(
            height: Dimensions.d_280,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.d_15, horizontal: Dimensions.d_30),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: Paddings.vertical_5,
                    child: Text(
                      "Pengesahan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: FontSizes.title,
                          color: Colours.darkGrey),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.d_30,
                  ),
                  Padding(
                    padding: Paddings.horizontal_5,
                    child: Text(
                      'Daftar berjaya! Sila klik Teruskan untuk menyerus ke halaman pengesahan.',
                      style: TextStyle(
                          fontSize: FontSizes.biggerText,
                          color: Colours.darkGrey),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.d_30,
                  ),
                  UserButton(
                    text: 'Teruskan',
                    color: isSLI ? Colours.orange : Colours.blue,
                    onClick: () {
                      // Popping all previous pages of the application before proceeding to verification page
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerificationPage()),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(Dimensions.d_10))),
          elevation: Dimensions.d_15,
        );
      });
}
