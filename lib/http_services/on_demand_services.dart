import 'dart:convert';
import 'package:heard/api/on_demand_request.dart';
import 'package:http/http.dart' as http;

class OnDemandServices {

  Future<List<OnDemandRequest>> getAllRequests({String headerToken}) async {
    var response = await http
        .get('https://heard-project.herokuapp.com/ondemand/all', headers: {
      'Authorization': headerToken,
    });

    print('Get all On-demand request: ${response.statusCode}, body: ${response.body}');

    List<OnDemandRequest> onDemandRequests = [];
    if (response.statusCode == 200) {
      List<dynamic> requestsBody = jsonDecode(response.body);
      for (int i = 0; i < requestsBody.length; i++) {
        OnDemandRequest request = OnDemandRequest.fromJson(requestsBody[i]);
        onDemandRequests.add(request);
      }
    }

    return onDemandRequests;
  }

  Future<String> acceptOnDemandRequest({String headerToken, String onDemandID}) async {
    var response = await http
        .post('https://heard-project.herokuapp.com/ondemand/accept', headers: {
      'Authorization': headerToken,
    }, body: {
      'on_demand_id': onDemandID,
    });

    print('Accept On-Demand Request: ${response.statusCode}, body: ${response.body}');

    if (response.statusCode == 200) {
      return 'Successfully Accepted Request';
    }
    else {
      return 'Failed to Accept Request';
    }
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