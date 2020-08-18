import 'package:flutter/material.dart';
import 'package:heard/schedule/schedule_page.dart';
import 'package:heard/startup/login_page.dart';
import 'package:heard/home/navigation.dart';
import 'package:heard/startup/startup_page.dart';

import 'startup/startup_page.dart';
//import 'package:heard/schedule/schedule_page.dart'; //for testing purpose
import 'firebase_services/fcm.dart';


void main() => runApp(App());

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var fcm = FCM();
    fcm.init();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartupPage(),
//      home: Navigation(isSLI: true,),
    );
  }
}