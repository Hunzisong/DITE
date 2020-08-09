import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heard/constants.dart';
import 'package:heard/home/on_demand/on_demand_sli_page.dart';

class SlidableListTile extends StatelessWidget {
  final Function onAccept;
  final UserInfoTemp userInfo;
  final bool isThreeLine;
  final Widget onTrailingButtonPress;

  SlidableListTile({this.onAccept, this.userInfo, this.isThreeLine = false, this.onTrailingButtonPress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: ListTile(
            contentPadding: EdgeInsets.all(Dimensions.d_20),
            isThreeLine: isThreeLine,
            leading: Icon(
              Icons.account_circle,
              size: Dimensions.d_55,
            ),
            title: Text('${userInfo.userName}', style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${userInfo.hospital}', style: TextStyle(color: Colours.darkGrey),),
                userInfo.isEmergency ? Text('*Kecemasan', style: TextStyle(color: Colours.fail),) : SizedBox.shrink(),
              ],
            ),
            trailing: onTrailingButtonPress != null ? onTrailingButtonPress : SizedBox.shrink(),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
                caption: 'Terima',
                color: Colours.accept,
                icon: Icons.done,
                onTap: onAccept),
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
