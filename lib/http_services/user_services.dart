import 'dart:convert';
import 'package:heard/api/user.dart';
import 'package:heard/landing/user_details.dart';
import 'package:http/http.dart' as http;

class UserServices {

  Future<User> getUser({String headerToken}) async {
    var response = await http
        .get('https://heard-project.herokuapp.com/user/me', headers: {
      'Authorization': headerToken,
    });

    print('Get User response: ${response.statusCode}, body: ${response.body}');

    User user;
    if (response.statusCode == 200) {
      Map<String, dynamic> userBody = jsonDecode(response.body);
      user = User.fromJson(userBody);
    }

    return user;
  }

  Future<void> createUser({String headerToken, UserDetails userDetails}) async {
    var response = await http
        .post('https://heard-project.herokuapp.com/user/create', headers: {
      'Authorization': headerToken,
    }, body: {
      'name': userDetails.fullName.text,
      'phone_no': userDetails.phoneNumber.text,
      'profile_pic': 'test1',
      'gender': userDetails.gender.toString().split('.').last,
      'age': userDetails.age.text,
    });

    print('Create User response: ${response.statusCode}, body: ${response.body}');
  }

  Future<bool> doesUserExist({String headerToken}) async {
    var response = await http
        .get('https://heard-project.herokuapp.com/user/exists', headers: {
      'Authorization': headerToken,
    });

    print('Does User Exists response: ${response.statusCode}, body: ${response.body}');

    Map<String, dynamic> userBody = jsonDecode(response.body);
    return userBody['exists'];
  }

  Future<void> deleteUser({String headerToken, String phoneNumber}) async {
    var response = await http
        .post('https://heard-project.herokuapp.com/user/delete', headers: {
      'Authorization': headerToken,
    }, body: {
      'phone': phoneNumber
    });

    print('Delete User response: ${response.statusCode}, body: ${response.body}');
  }
}