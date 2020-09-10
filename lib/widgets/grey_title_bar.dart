import 'package:flutter/material.dart';
import 'package:heard/constants.dart';

class GreyTitleBar extends StatelessWidget {
  final String title;
  final Widget trailing;

  GreyTitleBar({this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.grey,
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.d_20, vertical: Dimensions.d_10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing ?? SizedBox.shrink()
        ],
      ),
    );
  }
}
