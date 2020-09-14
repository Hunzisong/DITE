class User {
  String name;
  String gender;
  int age;
  String phoneNo;
  String profilePic;
  String createdAt;

  User(
      {this.name,
        this.gender,
        this.age,
        this.phoneNo,
        this.profilePic,
        this.createdAt});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gender = json['gender'];
    age = json['age'];
    phoneNo = json['phone_no'];
    profilePic = json['profile_pic'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['phone_no'] = this.phoneNo;
    data['profile_pic'] = this.profilePic;
    data['created_at'] = this.createdAt;
    return data;
  }
}
