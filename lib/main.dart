import 'package:flutter/material.dart';
import 'package:heard/landing/landing_page.dart';

//import 'package:heard/schedule/schedule_page.dart'; //for testing purpose


void main() => runApp(App());

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
//      home: Navigation(isSLI: true,),
    );
  }
}