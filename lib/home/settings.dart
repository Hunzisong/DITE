import 'package:flutter/material.dart';
import 'package:heard/services/auth_service.dart';
import 'package:heard/widgets/user_button.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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