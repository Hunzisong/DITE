class SLI {
  String firstName;
  String lastName;
  String profilePic;
  String phoneNo;
  String gender;
  String description;
  String experiencedMedical;
  String experiencedBim;

  SLI(
      {this.firstName,
        this.lastName,
        this.profilePic,
        this.phoneNo,
        this.gender,
        this.description,
        this.experiencedMedical,
        this.experiencedBim});

  SLI.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePic = json['profile_pic'];
    phoneNo = json['phone_no'];
    gender = json['gender'];
    description = json['description'];
    experiencedMedical = json['experienced_medical'];
    experiencedBim = json['experienced_bim'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_pic'] = this.profilePic;
    data['phone_no'] = this.phoneNo;
    data['gender'] = this.gender;
    data['description'] = this.description;
    data['experienced_medical'] = this.experiencedMedical;
    data['experienced_bim'] = this.experiencedBim;
    return data;
  }
}
