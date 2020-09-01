import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/home/booking/user_booking_page.dart';
import 'package:heard/schedule/schedule_page.dart';
import 'package:heard/chat_service/chatPage.dart';

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
      child: Text('Booking (in progress)'),
      color: Colours.grey,
      onPressed: () {
        Navigator.push(
          context,
          /// todo: push chat page here!
          MaterialPageRoute(builder: (context) => UserBookingPage()),
        );
      },
    ));
  }
}
