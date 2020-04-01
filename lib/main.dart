import 'package:flutter/material.dart';
import 'package:heard/startup/login.dart';
import 'package:heard/home/navigation.dart';
import 'package:heard/startup/startup_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartupPage(),
    );
  }
}