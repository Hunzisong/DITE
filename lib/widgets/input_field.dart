import 'package:flutter/material.dart';
import 'package:heard/constants.dart';

class InputField extends StatelessWidget {
  final isPassword;
  final labelText;
  final keyboardType;
  final TextEditingController controller;

  InputField({this.isPassword = false, this.labelText = '', this.keyboardType, @required this.controller});

  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.vertical_18,
      child: Material(
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: Paddings.horizontal_5,
            labelText: labelText,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 3.0, color: Colours.grey)
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 3.0, color: Colours.blue)
            ),
          )),
      )
    );
  }
}
