import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/services/auth_service.dart';
import 'package:heard/startup/login_page.dart';
import 'package:heard/widgets/input_field.dart';
import 'package:heard/widgets/user_button.dart';

class VerificationPage extends StatefulWidget {

  final String verificationId;
  VerificationPage({Key key, @required this.verificationId}) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();

}

class _VerificationPageState extends State<VerificationPage> {

  TextEditingController verificationNumberController = TextEditingController();

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text("Pengesahan Akaun")),
            body: Padding(
                padding: Paddings.startupMain,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: Dimensions.d_30),
                    Text("Masukkan kod dihantar melalui SMS"),
                    InputField(
                      controller: verificationNumberController,
                      labelText: "Kod anda",
                      keyboardType: TextInputType.phone,
                    ),
                    UserButton(
                      text: 'Teruskan',
                      color: Colours.lightBlue,
                      onClick: () {
                        AuthService().signInWithOTP(context, verificationNumberController.text, widget.verificationId);
                      },
                    ),
                  ],
                )
            )
        )
    );
  }
}
