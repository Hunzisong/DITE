import 'package:flutter/material.dart';
import 'package:heard/constants.dart';

class DropdownList extends StatelessWidget {

  final String hintText;
  final String selectedItem;
  final Function onChanged;
  final List <DropdownMenuItem <String>> itemList;

  DropdownList({this.hintText, this.selectedItem,this.itemList, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
          color: Colours.lightBlue,
          borderRadius:
          BorderRadius.all(Radius.circular(Dimensions.d_10))
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.d_15, vertical: Dimensions.d_3),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
              isExpanded: true,
              value: selectedItem,
              items: itemList,
              hint: new Text(hintText),
              iconSize: Dimensions.d_45,
              onChanged: onChanged,
             ),
        ),
      ),
    );
  }
}
