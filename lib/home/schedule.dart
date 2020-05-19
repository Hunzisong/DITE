import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/schedule/schedule_page.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule>
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
      child: Text('Schedule Page'),
      color: Colours.orange,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SchedulePage()),
        );
      },
    ));
  }
}
