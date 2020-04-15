import 'package:flutter/material.dart';
import 'package:heard/constants.dart';

class UserButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onClick;
  final double height;
  UserButton({this.text, this.color, this.onClick, this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.d_15, horizontal: Dimensions.d_5),
      child: ButtonTheme(
        height: height == null ? Dimensions.buttonHeight : height,
        minWidth: double.infinity,
        child: RaisedButton(
          elevation: Dimensions.d_5,
          color: color,
          onPressed: onClick,
          child: Text(
            text,
            style: TextStyle(fontSize: FontSizes.buttonText, fontWeight: FontWeight.bold),
          ),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.buttonRadius)),
        ),
      ),
    );
  }
}
