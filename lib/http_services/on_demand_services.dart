import 'dart:convert';
import 'package:heard/api/on_demand_request.dart';
import 'package:heard/home/on_demand/data_structure/OnDemandInputs.dart';
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

  Future<String> onDemandRequest({String headerToken, OnDemandInputs onDemandInputs}) async {
    var response = await http.post('https://heard-project.herokuapp.com/ondemand/request',
        headers: {
          'Authorization': headerToken,
        },
        body: {
          'hospital': onDemandInputs.hospital.text,
          'hospital_department': onDemandInputs.department.text,
          'emergency': onDemandInputs.isEmergency.toString(),
          'on_behalf': onDemandInputs.isBookingForOthers.toString(),
          'gender': onDemandInputs.genderType.toString(),
          'patient_name': onDemandInputs.patientName.text,
          'note': onDemandInputs.noteToSLI.text,
        }
    );

    if (response.statusCode == 200) {
      print("Success");
      return "Successful request";
    }
    else {
      print("Failed");
      return "Failed request";
    }
  }

  Future<String> onDemandCancel({String headerToken}) async {
    var response = await http.post('https://heard-project.herokuapp.com/ondemand/cancel',
        headers: {
          'Authorization': headerToken,
        }
    );

    if (response.statusCode == 200) {
      return 'Successfully Cancelled Request';
    }
    else {
      return 'Failed to Cancel Request';
    }
  }

  Future<String> onDemandEnd({String headerToken}) async {
    var response = await http.post('https://heard-project.herokuapp.com/ondemand/end',
        headers: {
          'Authorization': headerToken,
        }
    );

    if (response.statusCode == 200) {
      return 'Successfully Ended Request';
    }
    else {
      return 'Failed to End Request';
    }
  }

  Future<String> onDemandStatus({String headerToken, String userType}) async {
    var response = await http.post('https://heard-project.herokuapp.com/ondemand/status',
      headers: {
        'Authorization': headerToken,
      },
      body: {
        'type': userType,
      }
    );

    if (response.statusCode == 200) {
      return 'Successful Status';
    }
    else {
      return 'Status Failed';
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