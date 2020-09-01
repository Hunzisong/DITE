import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heard/api/on_demand_request.dart';
import 'package:heard/api/on_demand_status.dart';
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

  Future<bool> acceptOnDemandRequest({String headerToken, String onDemandID}) async {
    var response = await http
        .post('https://heard-project.herokuapp.com/ondemand/accept', headers: {
      'Authorization': headerToken,
    }, body: {
      'on_demand_id': onDemandID,
    });

    print('Accept On-Demand Request: ${response.statusCode}, body: ${response.body}');

    if (response.statusCode == 200) {
      return true;
    }
    else {
      return false;
    }
  }

  Future<OnDemandStatus> onDemandStatus({String headerToken, @required bool isSLI}) async {
    var response = await http
        .get('https://heard-project.herokuapp.com/ondemand/status', headers: {
      'Authorization': headerToken,
      'type': isSLI ? 'sli' : 'user',
    });

    print('Get On-Demand Status: ${response.statusCode}, body: ${response.body}');

    OnDemandStatus onDemandStatus;
    if (response.statusCode == 200) {
      Map<String, dynamic> statusBody = jsonDecode(response.body);
      onDemandStatus = OnDemandStatus.fromJson(statusBody);
    }

    return onDemandStatus;
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