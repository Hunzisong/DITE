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
        body: Padding(
          padding: Paddings.startupMain,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
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
                text: 'Log Masuk Sini!',
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
                text: 'Daftar Sini!',
                height: Dimensions.d_65,
                color: Colours.blue,
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
