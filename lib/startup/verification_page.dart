import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/services/auth_service.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class VerificationPage extends StatefulWidget {
  final String verificationId;
  VerificationPage({Key key, @required this.verificationId}) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController verificationNumberController = TextEditingController();
  bool showLoadingAnimation = false;

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colours.white,
            body: ModalProgressHUD(
              color: Colours.darkGrey,
              inAsyncCall: showLoadingAnimation,
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Padding(
                      padding: Paddings.signUpPage,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: Paddings.vertical_18,
                            child: Text(
                              'Pengesahan Akaun',
                              style: TextStyle(
                                  fontSize: FontSizes.title,
                                  fontWeight: FontWeight.bold,
                                  color: Colours.black),
                            ),
                          ),
                          SizedBox(height: Dimensions.d_65),
                          Text(
                            "Masukkan kod dihantar melalui SMS",
                            style: TextStyle(fontSize: FontSizes.buttonText),
                          ),
                          InputField(
                            controller: verificationNumberController,
                            labelText: "Kod anda",
                            keyboardType: TextInputType.phone,
                            isShortInput: true,
                          ),
                          UserButton(
                            text: 'Teruskan',
                            color: Colours.blue,
                            onClick: () {
                              setState(() {
                                showLoadingAnimation = true;
                              });
                              AuthService().signInWithOTP(
                                  context,
                                  verificationNumberController.text,
                                  widget.verificationId);
                            },
                          ),
                        ],
                      )),
                ],
              ),
            )));
  }
}
