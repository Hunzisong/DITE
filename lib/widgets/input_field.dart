import 'package:flutter/material.dart';
import 'package:heard/constants.dart';

class InputField extends StatelessWidget {
  final isPassword;
  final labelText;
  final keyboardType;
  final isShortInput;
  final hintText;
  final TextEditingController controller;

  InputField({this.isPassword = false, this.labelText = '', this.hintText = '', this.keyboardType, this.isShortInput = false, @required this.controller});

  Widget build(BuildContext context) {
    return Padding(
      padding: isShortInput ? EdgeInsets.symmetric(vertical: Dimensions.d_30, horizontal: Dimensions.d_100) : Paddings.vertical_18,
      child: Material(
        color: Colours.white,
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          textAlign: isShortInput ? TextAlign.center : TextAlign.start,
          decoration: InputDecoration(
            contentPadding: Paddings.horizontal_5,
            hintText: hintText,
            hintStyle: TextStyle(color: Colours.grey),
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
