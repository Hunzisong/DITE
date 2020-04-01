import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final phoneNumberField = TextField(
        obscureText: false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
          hintText: "Phone Number",
        ));

    final passwordField = TextField(
        obscureText: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
          hintText: "Password",
        ));

    final loginButtonUser = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.grey,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        onPressed: () {},
        child: Text("Login As User",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final loginButtonSLI = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue[200],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        onPressed: () {},
        child: Text("Login As SLI",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final signUpButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        onPressed: () {},
        child: Text("New? Signup Now!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Text("HEARD", style: TextStyle(fontSize: 30)),
                      SizedBox(
                        height: 50.0,
                        child: Image.asset(
                          "assets/logo.png",
                          //////////////////////// ENTER IMAGE HERE ////////////////////////////////
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 45.0),
                      FractionallySizedBox(
                          widthFactor: 1,
                          child: Text(
                              "PHONE NUMBER",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 10)
                          )
                      ),
                      phoneNumberField,
                      SizedBox(height: 25.0),
                      FractionallySizedBox(
                          widthFactor: 1,
                          child: Text(
                              "PASSWORD",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 10)
                          )
                      ),
                      passwordField,
                      SizedBox(
                        height: 35.0,
                      ),
                      loginButtonUser,
                      SizedBox(
                        height: 15.0,
                      ),
                      loginButtonSLI,
                      SizedBox(
                        height: 15.0,
                      ),
                      signUpButton,
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              )
          )
      ),
    );
  }
}
