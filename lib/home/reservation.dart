import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/schedule/schedule_page.dart';

class Reservation extends StatefulWidget {
  @override
  _ReservationState createState() => _ReservationState();
}

class _ReservationState extends State<Reservation>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
        child: FlatButton(
      child: Text('Chat Page'),
      color: Colours.grey,
      onPressed: () {
        Navigator.push(
          context,
          /// todo: push chat page here!
          MaterialPageRoute(builder: (context) => SchedulePage()),
        );
      },
    ));
  }
}
