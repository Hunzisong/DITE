import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heard/constants.dart';

class SlidableListTile extends StatelessWidget {
  final Function onTap;
  final String name;

  SlidableListTile({this.onTap, this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: ListTile(
            contentPadding: EdgeInsets.all(Dimensions.d_20),
            leading: Icon(
              Icons.account_circle,
              size: Dimensions.d_45,
            ),
            title: Text('Nama: $name'),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
                caption: 'Terima',
                color: Colours.accept,
                icon: Icons.done,
                onTap: onTap),
          ],
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
