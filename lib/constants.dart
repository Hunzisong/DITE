import 'package:flutter/material.dart';

class Paddings {
  static EdgeInsetsGeometry startupMain = EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0);
  static EdgeInsetsGeometry signUpPage = EdgeInsets.only(bottom: 35.0, left: 30.0, right: 30.0);
  static EdgeInsetsGeometry horizontal_5 = EdgeInsets.symmetric(horizontal: 5.0);
  static EdgeInsetsGeometry horizontal_20 = EdgeInsets.symmetric(horizontal: 20.0);
  static EdgeInsetsGeometry vertical_5 = EdgeInsets.symmetric(vertical: 5.0);
  static EdgeInsetsGeometry vertical_15 = EdgeInsets.symmetric(vertical: 15.0);
  static EdgeInsetsGeometry vertical_18 = EdgeInsets.symmetric(vertical: 18.0);
  static EdgeInsetsGeometry vertical_35 = EdgeInsets.symmetric(vertical: 35.0);
}

class Dimensions {
  static double buttonRadius = 30.0;
  static double buttonHeight = 55.0;
  static double d_5 = 5.0;
  static double d_10 = 10.0;
  static double d_15 = 15.0;
  static double d_30 = 30.0;
  static double d_45 = 45.0;
  static double d_65 = 65.0;
  static double d_100 = 100.0;
  static double d_140 = 140.0;
  static double d_280 = 280.0;
}

class FontSizes {
  static double title = 25.0;
  static double buttonText = 20.0;
  static double normal = 16.0;
  static double smallerText = 15.0;
}

class Colours {
  static Color white = Colors.white;
  static Color lightBlue = Colors.blue[100];
  static Color blue = Color(0xFF75A9F1);
  static Color darkBlue = Color(0xFF3A7AF9);
  static Color grey = Colors.grey[350];
  static Color darkGrey = Colors.grey[600];
  static Color black = Colors.black87;
  static Color success = Color(0xFF0AC380);
  static Color fail = Colors.redAccent;
}

enum gender {male, female}
