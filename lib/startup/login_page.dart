import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/home/navigation.dart';
import 'package:heard/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneNumberText = TextEditingController();
  TextEditingController passwordText = TextEditingController();

  Widget build(BuildContext context) {
    return SafeArea(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Navigation()),
                        );
                        phoneNumberText.dispose();
                        passwordText.dispose();
                        Navigator.pop(context);
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
                        phoneNumberText.dispose();
                        passwordText.dispose();
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
}
