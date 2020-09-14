import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/widgets/widgets.dart';


class UserBookingResultPage extends StatefulWidget {
  @override
  _UserBookingResultPageState createState() => _UserBookingResultPageState();
}

class _UserBookingResultPageState extends State<UserBookingResultPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colours.white,
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(Dimensions.d_30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: SizedBox(
                      height: Dimensions.d_160,
                      child: Text(
                        "Results list..."
                      )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
