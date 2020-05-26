import 'package:flutter/material.dart';
import 'package:heard/constants.dart';

class UserButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onClick;
  final double height;
  final EdgeInsetsGeometry padding;
  UserButton({this.text, this.color, this.onClick, this.height, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding == null
          ? EdgeInsets.symmetric(
              vertical: Dimensions.d_15, horizontal: Dimensions.d_5)
          : padding,
      child: ButtonTheme(
        height: height == null ? Dimensions.buttonHeight : height,
        minWidth: double.infinity,
        child: RaisedButton(
          elevation: Dimensions.d_5,
          color: color,
          onPressed: onClick,
          child: Text(
            text,
            style: TextStyle(
                fontSize: FontSizes.buttonText, fontWeight: FontWeight.bold, color: Colours.white),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.buttonRadius)),
        ),
      ),
    );
  }
}
