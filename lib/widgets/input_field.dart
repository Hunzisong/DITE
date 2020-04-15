import 'package:flutter/material.dart';
import 'package:heard/constants.dart';

class InputField extends StatelessWidget {
  final isPassword;
  final labelText;

  InputField({this.isPassword = false, this.labelText = ''});

  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.vertical_15,
      child: TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            contentPadding: Paddings.horizontal_5,
            labelText: labelText
          )),
    );
  }
}
