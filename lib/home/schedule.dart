import 'package:flutter/material.dart';
import 'package:heard/schedule/schedule_page.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return SchedulePage();
  }
}