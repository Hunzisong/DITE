import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heard/constants.dart';

class SlidableListTile extends StatelessWidget {
  final List<Widget> slideActionFunctions;
  final Widget onTrailingButtonPress;
  final Color tileColour;
  final Widget title;
  final Widget subtitle;

  SlidableListTile({this.slideActionFunctions, this.onTrailingButtonPress, this.tileColour, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Material(
          color: tileColour != null ? tileColour : Colours.white,
          child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: ListTile(
              contentPadding: EdgeInsets.all(Dimensions.d_20),
              isThreeLine: true,
              leading: Icon(
                Icons.account_circle,
                size: Dimensions.d_55,
              ),
              title: title,
              subtitle: subtitle,
              trailing: onTrailingButtonPress != null ? onTrailingButtonPress : SizedBox.shrink(),
            ),
            secondaryActions: slideActionFunctions,
          ),
        ),
        Divider(
          height: Dimensions.d_0,
          thickness: Dimensions.d_3,
          color: Colours.lightGrey,
        )
      ],
    );
  }
}
