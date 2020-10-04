import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';

class User {
  TextEditingController name = TextEditingController();
  String gender;
  String phoneNo;
  File profilePic;
  String description;
  bool experienced_medical;
  bool experienced_bim;
  int years_medical;
  int years_bim;
  TextEditingController age = TextEditingController();
  String createdAt;
  String sli_id;
  bool asl_proficient;
  bool bim_proficient;
  TextEditingController education = TextEditingController();

  User({
    this.name,
    this.gender,
    this.phoneNo,
    this.profilePic,
    this.description,
    this.experienced_medical,
    this.experienced_bim,
    this.years_medical,
    this.years_bim,
    this.createdAt,
    this.sli_id,
    this.asl_proficient,
    this.bim_proficient,
    this.education,
  });

  User.fromJson(Map<String, dynamic> json) {
    name.text = json['name'];
    gender = json['gender'];
    phoneNo = json['phone_no'];
    setProfilePicture(json['profile_pic']);
    description = json['description'];
    experienced_medical = json['experienced_medical'];
    experienced_bim = json['experienced_bim'];
    years_medical = json['years_medical'];
    years_bim = json['years_bim'];
    age.text = json['age'].toString();
    createdAt = json['created_at'];
    sli_id = json['sli_id'];
    asl_proficient = json['asl_proficient'];
    bim_proficient = json['bim_proficient'];
    education.text = json['education'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name.text;
    data['gender'] = this.gender;
    data['phone_no'] = this.phoneNo;
    data['profile_pic'] = this.profilePic.readAsStringSync();
    data['description'] = this.description;
    data['experienced_medical'] = this.experienced_medical;
    data['experienced_bim'] = this.experienced_bim;
    data['years_medical'] = this.years_medical;
    data['years_bim'] = this.years_bim;
    data['age'] = this.age.text;
    data['created_at'] = this.createdAt;
    data['sli_id'] = this.sli_id;
    data['asl_proficient'] = this.asl_proficient;
    data['bim_proficient'] = this.bim_proficient;
    data['education'] = this.education.text;
    return data;
  }

  void setProfilePicture(String profilePicture) {
    if (profilePicture == 'test1') {
      profilePic = null;
    }
    else {
      profilePic = File('decodedProfilePic.png');
      profilePic.writeAsBytesSync(base64Decode(profilePicture));
    }
  }
}
