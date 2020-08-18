import 'dart:convert';

class UserExists {
  bool exists;

  UserExists({this.exists});

  UserExists.fromJson(String jsonString) {
    Map<String, dynamic> isUserExists = jsonDecode(jsonString);
    exists = isUserExists['exists'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exists'] = this.exists;
    return data;
  }
}