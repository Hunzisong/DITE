import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:heard/constants.dart';

class CheckBoxTile extends StatefulWidget {
  final bool value;
  final Function onChanged;
  final String text;
  final String textLink;
  final String textLinkURL;

  CheckBoxTile(
      {this.onChanged,
        this.value,
        this.text,
        this.textLink,
        this.textLinkURL});

  @override
  _CheckBoxTileState createState() => _CheckBoxTileState();
}

class _CheckBoxTileState extends State<CheckBoxTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(Dimensions.d_0),
      leading: SizedBox(
        height: Dimensions.checkBoxSize,
        width: Dimensions.checkBoxSize,
        child: Checkbox(
          value: widget.value,
          onChanged: widget.onChanged,
        ),
      ),
      title: RichText(
        text: TextSpan(
            children: [
              TextSpan(
                text: widget.text,
                style: TextStyle(
                    color: Colours.darkGrey,
                    fontWeight: FontWeight.w600, fontSize: FontSizes.smallerText),
              ),
              TextSpan(
                text: widget.textLink,
                style: TextStyle(
                    color: Colours.darkBlue,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                    fontSize: FontSizes.smallerText),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    /// todo: add url link for terms and conditions
//                  launch(widget.textLinkURL);
                  },
              )
            ]
        ),
      ),
    );
  }
}