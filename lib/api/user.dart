class User {
  String firstName;
  String lastName;
  String profilePic;
  String phoneNo;

  User({this.firstName, this.lastName, this.profilePic, this.phoneNo});

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePic = json['profile_pic'];
    phoneNo = json['phone_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_pic'] = this.profilePic;
    data['phone_no'] = this.phoneNo;
    return data;
  }
}