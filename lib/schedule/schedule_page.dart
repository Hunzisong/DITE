import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/widgets/widgets.dart';

import '../constants.dart';
import '../constants.dart';
import '../constants.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Jadual",
          style: TextStyle(
            fontSize: FontSizes.title,
          ),
        ),
        centerTitle: true,
        backgroundColor:Colours.blue,
      ),
      body: ListView(
        children: <Widget>[
          Column(
          crossAxisAlignment:CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: Colours.blue,
              height: Dimensions.d_45,
              child: Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                children: <Widget>[
                  Text(
                    '  Isnin',
                    style: TextStyle(
                      fontSize: FontSizes.title,
                      fontWeight: FontWeight.bold,
                      color: Colours.white,
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: Colours.white,
                      ),
                      onPressed: (){}
                  ),
                ],
              ),
            ),
            Container(
              color: Colours.white,
              height: Dimensions.d_100,
              child: Row(
                children: <Widget>[
                  Container(
                    child:Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                      children: <Widget>[
                        Text(
                          "1000 - 1230",
                          style: TextStyle(
                            fontSize: FontSizes.buttonText,
                            color: Colours.white,
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: Colours.white,
                              size: Dimensions.d_30,
                            ),
                            onPressed: (){}
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color:Colours.lightBlue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0)
                      ),
                    ),
                    margin: EdgeInsets.all(15.0),
                    padding: EdgeInsets.all(10.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ]
      ),
    );
  }
}

