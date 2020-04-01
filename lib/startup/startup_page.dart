import 'package:flutter/material.dart';
import 'package:heard/startup/login.dart';

class StartupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 55.0, horizontal: 30.0),
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Center(
                  child: Text(
                'HEARD',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: 280,
                child: Icon(Icons.headset_off,
                    size: 180, color: Colors.blueAccent),
              ),
              UserButton(
                text: 'Login here!',
                color: Colors.grey[350],
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
              UserButton(
                text: 'New? Sign up now!',
                color: Colors.blue[200],
                onClick: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onClick;
  UserButton({this.text, this.color, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 5),
      child: ButtonTheme(
        height: 60.0,
        minWidth: double.infinity,
        child: RaisedButton(
          elevation: 5.0,
          color: color,
          onPressed: onClick,
          child: Text(
            text,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
      ),
    );
  }
}
