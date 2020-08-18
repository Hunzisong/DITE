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
    return Center(
      child: Container(
        child: UserButton(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.d_35),
          color: widget.isSLI ? Colours.orange : Colours.blue,
          text: "Log Out",
          onClick: () => AuthService().signOut(context),
        )
      ),
    );
  }
}