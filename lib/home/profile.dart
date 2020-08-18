import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/firebase_services/auth_service.dart';
import 'package:heard/widgets/user_button.dart';

class Profile extends StatefulWidget {
  final bool isSLI;

  Profile({this.isSLI = false});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.d_35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          UserButton(
            color: widget.isSLI ? Colours.orange : Colours.blue,
            text: "Log Out",
            onClick: () => AuthService().signOut(context),
          ),
          UserButton(
            color: widget.isSLI ? Colours.orange : Colours.blue,
            text: "Delete Account",
            onClick: () {
              AuthService().deleteAndSignOut(context);
            },
          ),
        ],
      ),
    );
  }
}
