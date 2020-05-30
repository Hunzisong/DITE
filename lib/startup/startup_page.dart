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
                    height: Dimensions.d_15,
                  ),
                  UserButton(
                    text: 'Log Masuk',
                    textColour: Colours.darkGrey,
                    height: Dimensions.d_65,
                    color: Colours.grey,
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                  SizedBox(
                    height: Dimensions.d_15,
                  ),
                  Padding(
                    padding: EdgeInsets.all(Dimensions.d_10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            color: Colours.darkGrey,
                            thickness: Dimensions.d_1,
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Text(
                            'Pengguna baru? Daftar sekarang!',
                            style: TextStyle(
                              color: Colours.darkGrey,
                              fontWeight: FontWeight.w500
                            ),
                            textAlign: TextAlign.center ,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colours.darkGrey,
                            thickness: Dimensions.d_1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  UserButton(
                    text: 'Daftar Sebagai Pengguna',
                    height: Dimensions.buttonHeight,
                    color: Colours.blue,
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.d_5),
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                  ),
                  UserButton(
                    text: 'Daftar Sebagai JBIM',
                    height: Dimensions.buttonHeight,
                    color: Colours.orange,
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
