import 'package:flutter/material.dart';
import 'package:heard/constants.dart';

class FieldLabel extends StatelessWidget {
  final String text;
  FieldLabel({this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: FontSizes.normal,
          color: Colours.darkGrey),
    );
  }
}
