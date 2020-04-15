import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/home/navigation.dart';
import 'package:heard/widgets/widgets.dart';

class Login extends StatelessWidget {
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
                      child: Image.asset(
                        'images/diteLogo.png',
                      ),
                    ),
                    SizedBox(height: Dimensions.d_30),
                    InputField(
                      labelText: 'Phone Number',
                    ),
                    InputField(
                      labelText: 'Password',
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
                      },
                    ),
                    UserButton(
                      text: 'Log Masuk Sebagai BIM',
                      color: Colours.lightBlue,
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Navigation()),
                        );
                      },
                    ),
                    Padding(
                      padding: Paddings.vertical_15,
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'I\'ve forgot my password',
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
