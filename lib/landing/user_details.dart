import 'package:flutter/material.dart';
import 'package:heard/constants.dart';

class UserDetails {
  TextEditingController fullName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  bool hasExperience = false;
  bool isFluent = false;
  bool termsAndConditions = false;
  bool isSLI = false;
  Gender gender;

  void disposeTexts() {
    fullName.dispose();
    phoneNumber.dispose();
  }

  void setUserType({bool isSLI}) {
    this.isSLI = isSLI;
  }
}
