import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/widgets/widgets.dart';

Future<void> popUpDialog(
    {BuildContext context,
    bool isSLI,
    bool touchToDismiss = true,
    double height,
    String header = '',
    @required Widget content,
    String buttonText = 'Tutup',
    Function onClick}) async {
  return showDialog(
      context: context,
      barrierDismissible: touchToDismiss,
      builder: (context) {
        return Dialog(
          child: Container(
            height: height != null ? height : Dimensions.d_280,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.d_15, horizontal: Dimensions.d_30),
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Padding(
                    padding: Paddings.vertical_5,
                    child: Text(
                      header,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: FontSizes.mainTitle,
                          color: Colours.darkGrey),
                    ),
                  ),
                  Padding(
                    padding: Paddings.horizontal_5,
                    child: content
                  ),
                  UserButton(
                      text: buttonText,
                      color: isSLI ? Colours.orange : Colours.blue,
                      onClick: onClick)
                ],
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(Dimensions.d_10))),
          elevation: Dimensions.d_15,
        );
      });
}
