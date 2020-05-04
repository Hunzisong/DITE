import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/startup/login_page.dart';
import 'package:heard/startup/signup_page.dart';
import 'package:heard/widgets/widgets.dart';

class StartupPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Padding(
              padding: Paddings.startupMain,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: Dimensions.d_15,
                  ),
                  Container(
                    padding: Paddings.vertical_15,
                    height: Dimensions.d_280,
                    child: Hero(
                      tag: 'appLogo',
                      child: Image(
                        image: AssetImage('images/diteLogo.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.d_30,
                  ),
                  UserButton(
                    text: 'Log Masuk',
                    height: Dimensions.d_65,
                    color: Colours.grey,
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                  UserButton(
                    text: 'Daftar Sebagai Pengguna',
                    height: Dimensions.d_65,
                    color: Colours.lightBlue,
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                  ),
                  UserButton(
                    text: 'Daftar Sebagai JBIM',
                    height: Dimensions.d_65,
                    color: Colours.blue,
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage(isSLI: true)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
