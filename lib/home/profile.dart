import 'package:flutter/material.dart';
import 'package:heard/firebase_services/auth_service.dart';
import 'package:heard/widgets/user_button.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: UserButton(
        text: "Log out",
        onClick: () => AuthService().signOut(context),
      )
    );
  }
}