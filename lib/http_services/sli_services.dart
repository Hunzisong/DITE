import 'dart:convert';
import 'package:heard/api/sli.dart';
import 'package:heard/startup/user_details.dart';
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
      'name': sliDetails.fullName.text,
      'phone_no': sliDetails.phoneNumber.text,
      'profile_pic': 'test1',
      'gender': sliDetails.gender.toString().split('.').last,
      'description': 'test1',
      'experienced_medical': sliDetails.hasExperience.toString(),
      'experienced_bim': sliDetails.isFluent.toString(),
    });
    print('Create SLI response: ${response.statusCode}, body: ${response.body}');
  }

  Future<bool> doesSLIExist({String headerToken}) async {
    var response = await http
        .get('https://heard-project.herokuapp.com/sli/exists', headers: {
      'Authorization': headerToken,
    });

    print('Does SLI Exists response: ${response.statusCode}, body: ${response.body}');

    Map<String, dynamic> sliBody = jsonDecode(response.body);
    return sliBody['exists'];
  }

  Future<void> deleteSLI({String headerToken, String phoneNumber}) async {
    var response = await http
        .post('https://heard-project.herokuapp.com/sli/delete', headers: {
      'Authorization': headerToken,
    }, body: {
      'phone': phoneNumber
    });

    print('Delete SLI response: ${response.statusCode}, body: ${response.body}');
  }
}