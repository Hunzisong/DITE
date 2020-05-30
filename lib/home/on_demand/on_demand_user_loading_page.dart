import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:heard/constants.dart';
import 'package:heard/widgets/widgets.dart';

class OnDemandUserLoadingPage extends StatelessWidget {
  final Function onCancelClick;
  final Function onSearchComplete;

  OnDemandUserLoadingPage({this.onCancelClick, this.onSearchComplete});

  final Duration _duration = Duration(seconds: 3);

  startTimeout() {
    return Timer(_duration, onSearchComplete);
  }

  @override
  Widget build(BuildContext context) {
    Timer timer = startTimeout();
    return Scaffold(
      backgroundColor: Colours.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitRing(
            color: Colours.blue,
            lineWidth: Dimensions.d_5,
          ),
          Padding(
            padding: EdgeInsets.only(top: Dimensions.d_15),
            child: Text(
              'Sedang memuatkan, sila bersabar ...',
              style: TextStyle(fontSize: FontSizes.smallerText,),
            ),
          )
        ],
      ),
      bottomNavigationBar: UserButton(
          text: 'Batal',
          padding: EdgeInsets.all(Dimensions.d_30),
          color: Colours.cancel,
          onClick: () {
            onCancelClick();
            timer.cancel();
          }),
    );
  }
}
