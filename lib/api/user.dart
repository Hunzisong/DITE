import 'package:flutter/cupertino.dart';

class User {
  TextEditingController name = TextEditingController();
  String gender;
  String phoneNo;
  String profilePic;
  String description;
  bool experienced_medical;
  bool experienced_bim;
  int years_medical;
  int years_bim;
  int age;
  String createdAt;

  User(
      {this.name,
        this.gender,
        this.phoneNo,
        this.profilePic,
        this.description,
        this.experienced_medical,
        this.experienced_bim,
        this.years_medical,
        this.years_bim,
        this.createdAt});

  User.fromJson(Map<String, dynamic> json) {
    name.text = json['name'];
    gender = json['gender'];
    phoneNo = json['phone_no'];
    profilePic = json['profile_pic'];
    description = json['description'];
    experienced_medical = json['experienced_medical'];
    experienced_bim = json['experienced_bim'];
    years_medical = json['years_medical'];
    years_bim = json['years_bim'];
    age = json['age'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['phone_no'] = this.phoneNo;
    data['profile_pic'] = this.profilePic;
    data['description'] = this.description;
    data['experienced_medical'] = this.experienced_medical;
    data['experienced_bim'] = this.experienced_bim;
    data['years_medical'] = this.years_medical;
    data['years_bim'] = this.years_bim;
    data['age'] = this.age;
    data['created_at'] = this.createdAt;
    return data;
  }
}
