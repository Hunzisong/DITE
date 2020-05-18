import 'package:flutter/material.dart';
import 'package:heard/constants.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colours.orange,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colours.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Jadual',
            style: TextStyle(
                fontSize: FontSizes.mainTitle,
                fontWeight: FontWeight.bold,
                color: Colours.white),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        backgroundColor: Colours.white,
        body: ListView(
          children: <Widget>[
            Column(
            crossAxisAlignment:CrossAxisAlignment.stretch,
            children: <Widget>[
              ScheduleSlot(title: 'Isnin', timeSlots: [
                '1000 - 1230',
                '1100 - 1330',
                '1100 - 1430',
                '1100 - 1530',
              ],),
              ScheduleSlot(title: 'Selesa', timeSlots: [
                '1100 - 1630',
                '1100 - 1730',
              ],),
              ScheduleSlot(title: 'Rabu', timeSlots: [
                '1000 - 1630',
              ],),
              ScheduleSlot(title: 'Khamis'),
              ScheduleSlot(title: 'Jumaat', timeSlots: [
                '1000 - 1230',
                '1000 - 1030',
                '1130 - 1330',
              ],),
            ],
          ),
        ]
        ),
      ),
    );
  }
}

class ScheduleSlot extends StatelessWidget {
  final String title;
  final List<String> timeSlots;

  ScheduleSlot({this.title, this.timeSlots = const []});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Card(
          color: Colours.lightOrange,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.zero,
          ) ,
          borderOnForeground: true,
          elevation: 0,
          margin: EdgeInsets.fromLTRB(0,0,0,0),
          child: ListTile(
            title: Padding(
              padding: Paddings.horizontal_5,
              child: Text(
                      title,
                      style: TextStyle(
                        fontSize: FontSizes.title,
                        fontWeight: FontWeight.bold,
                        color: Colours.darkGrey,
                      ),
                    ),
            ),
            trailing: IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Colours.darkGrey,
                      size: Dimensions.d_30,
                    ),
                    onPressed: (){}
                ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.d_15, vertical: Dimensions.d_10),
          child: TimeSlots(timeSlots: timeSlots,),
        ),
      ],
    );
  }
}


class TimeSlotList extends StatefulWidget {
  final List<String> timeSlots;

  TimeSlotList({this.timeSlots});

  @override
  State createState() => TimeSlotListState();
}

class TimeSlotListState extends State<TimeSlotList> {
  Iterable<Widget> get timeSlotWidgets sync* {
    for (final String timeSlot in widget.timeSlots) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: Chip(
          deleteIconColor: Colours.white,
          backgroundColor: Colours.orange,
          label: Text(timeSlot),
          labelStyle: TextStyle(
            fontSize: FontSizes.normal,
            fontWeight: FontWeight.w500,
            color: Colours.darkGrey
          ),
          onDeleted: () {
            setState(() {
              widget.timeSlots.removeWhere((String entry) {
                return entry == timeSlot;
              });
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: timeSlotWidgets.toList(),
    );
  }
}

class TimeSlots extends StatefulWidget {
  final List<String> timeSlots;

  TimeSlots({this.timeSlots});

  @override
  _TimeSlotsState createState() => _TimeSlotsState();
}

class _TimeSlotsState extends State<TimeSlots> {
  @override
  Widget build(BuildContext context) {
    return TimeSlotList(timeSlots: widget.timeSlots,);
  }
}
