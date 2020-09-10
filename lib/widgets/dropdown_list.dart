import 'package:flutter/material.dart';
import 'package:heard/constants.dart';

class DropdownList extends StatelessWidget {

  final String hintText;
  String selectedItem;
  Function onChanged;
  List <DropdownMenuItem <String>> itemList;

  DropdownList({this.hintText, this.selectedItem,this.itemList, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Colours.lightOrange,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.d_15, vertical: Dimensions.d_3),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
              isExpanded: true,
              value: selectedItem,
              items: itemList,
              hint: new Text(hintText),
              iconSize: Dimensions.d_45,
              onChanged: (value){
                selectedItem= value;
                (context as Element).markNeedsBuild();
              }),
        ),
      ),
    );
  }
}
