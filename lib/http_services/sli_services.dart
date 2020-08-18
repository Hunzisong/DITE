import 'dart:convert';
import 'package:heard/api/sli.dart';
import 'package:heard/startup/signup_page.dart';
import 'package:http/http.dart' as http;

class SLIServices {

  Future<SLI> getSLI({String headerToken}) async {
    var response = await http
        .get('https://heard-project.herokuapp.com/sli/me', headers: {
      'Authorization': headerToken,
    });

    print('Get SLI response: ${response.statusCode}, body: ${response.body}');

    SLI sli;
    if (response.statusCode == 200) {
      Map<String, dynamic> sliBody = jsonDecode(response.body);
      sli = SLI.fromJson(sliBody);
    }

    return sli;
  }

  Future<void> createSLI({String headerToken, UserDetails sliDetails}) async {
    var response = await http
        .post('https://heard-project.herokuapp.com/sli/create', headers: {
      'Authorization': headerToken,
    }, body: {
      'name': sliDetails.fullName,
      'phone_no': sliDetails.phoneNumber,
      'profile_pic': 'test1',
      'gender': sliDetails.gender,
      'description': 'test1',
      'experienced_medical': sliDetails.hasExperience,
      'experienced_bim': sliDetails.isFluent,
    });

    print('Create SLI response: ${response.statusCode}, body: ${response.body}');
  }

//  Future<bool> doesUserExist({String headerToken}) async {
//    var response = await http
//        .get('https://heard-project.herokuapp.com/user/exists', headers: {
//      'Authorization': headerToken,
//    });
//
//    print('Does User Exists response: ${response.statusCode}, body: ${response.body}');
//
//    Map<String, dynamic> userBody = jsonDecode(response.body);
//    return userBody['exists'];
//  }
//
//  Future<void> deleteUser({String headerToken, String phoneNumber}) async {
//    var response = await http
//        .post('https://heard-project.herokuapp.com/user/delete', headers: {
//      'Authorization': headerToken,
//    }, body: {
//      'phone': phoneNumber
//    });
//
//    print('Delete User response: ${response.statusCode}, body: ${response.body}');
//  }
}