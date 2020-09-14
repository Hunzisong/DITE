import 'package:flutter/cupertino.dart';

class SLI {
  TextEditingController name = TextEditingController();
  String gender;
  String phoneNo;
  String profilePic;
  String description;
  bool experiencedMedical;
  bool experiencedBim;
  int yearsMedical;
  int yearsBim;
  String createdAt;

  SLI(
      {this.name,
        this.gender,
        this.phoneNo,
        this.profilePic,
        this.description,
        this.experiencedMedical,
        this.experiencedBim,
        this.yearsMedical,
        this.yearsBim,
        this.createdAt});

  SLI.fromJson(Map<String, dynamic> json) {
    name.text = json['name'];
    gender = json['gender'];
    phoneNo = json['phone_no'];
    profilePic = json['profile_pic'];
    description = json['description'];
    experiencedMedical = json['experienced_medical'];
    experiencedBim = json['experienced_bim'];
    yearsMedical = json['years_medical'];
    yearsBim = json['years_bim'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['phone_no'] = this.phoneNo;
    data['profile_pic'] = this.profilePic;
    data['description'] = this.description;
    data['experienced_medical'] = this.experiencedMedical;
    data['experienced_bim'] = this.experiencedBim;
    data['years_medical'] = this.yearsMedical;
    data['years_bim'] = this.yearsBim;
    data['created_at'] = this.createdAt;
    return data;
  }
}
