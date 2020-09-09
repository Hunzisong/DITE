import 'package:flutter/material.dart';
import 'package:heard/constants.dart';

class DropdownList extends StatelessWidget {

  final String hintText;
  String selectedItem;
  List <DropdownMenuItem <String>> itemList;

  DropdownList({this.hintText, this.selectedItem,this.itemList});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.lightBlue,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.d_95, vertical: Dimensions.d_5),
      child: DropdownButtonHideUnderline(
        child: new DropdownButton(
            value: selectedItem,
            items: itemList,
            hint: new Text(hintText),
            iconSize: Dimensions.d_45,
            onChanged: (value){
              selectedItem= value;
              (context as Element).markNeedsBuild();
            }),
    ),
    );
  }
}
