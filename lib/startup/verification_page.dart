import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/firebase_services/auth_service.dart';
import 'package:heard/startup/signup_page.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class VerificationPage extends StatefulWidget {
  final String verificationId;
  final UserDetails userDetails;
  VerificationPage({Key key, @required this.verificationId, this.userDetails})
      : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController verificationNumberController = TextEditingController();
  bool showLoadingAnimation = false;

  @override
  void dispose() {
    super.dispose();
    verificationNumberController.dispose();
    print('Disposed text editor on verification page');
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colours.white,
            appBar: AppBar(
              backgroundColor: Colours.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                'Pengesahan Akaun',
                style: TextStyle(
                    fontSize: FontSizes.mainTitle,
                    fontWeight: FontWeight.bold,
                    color: Colours.black),
              ),
              centerTitle: true,
              elevation: 0.0,
            ),
            body: ModalProgressHUD(
              inAsyncCall: showLoadingAnimation,
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Padding(
                      padding: Paddings.signUpPage,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
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
                                  context: context,
                                  userDetails: widget.userDetails,
                                  smsCode: verificationNumberController.text,
                                  verId: widget.verificationId);
                            },
                          ),
                        ],
                      )),
                ],
              ),
            )));
  }
}
