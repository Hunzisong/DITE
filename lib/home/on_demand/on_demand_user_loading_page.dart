import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:heard/constants.dart';
import 'package:heard/firebase_services/auth_service.dart';
import 'package:heard/firebase_services/fcm.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:heard/http_services/on_demand_services.dart';
import 'package:heard/home/on_demand/data_structure/OnDemandInputs.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:heard/http_services/user_services.dart';
import 'package:heard/api/user.dart';
import 'package:heard/api/on_demand_status.dart';

class OnDemandUserLoadingPage extends StatefulWidget {
  OnDemandUserLoadingPage({Key key, @required this.onCancelClick, @required this.onSearchComplete, @required this.onDemandInputs}) : super(key: key);
  final Function onCancelClick;
  final Function onSearchComplete;
  final OnDemandInputs onDemandInputs;

  @override
  OnDemandUserLoadingPageState createState() => new OnDemandUserLoadingPageState();
}

class OnDemandUserLoadingPageState extends State<OnDemandUserLoadingPage> {
  String _authToken;
  String _onDemandRequest;

  @override
  void initState() {
    super.initState();
    onDemandRequest();
  }

  void onDemandRequest() async {
    _authToken = await AuthService.getToken();
    if (widget.onDemandInputs.patientName.text.isEmpty) {
      User _user = await UserServices().getUser(headerToken: _authToken);
      String _username = _user.name;
      widget.onDemandInputs.patientName = TextEditingController.fromValue(TextEditingValue(text: _username));
    }
    _onDemandRequest = await OnDemandServices().makeOnDemandRequest(headerToken: _authToken, onDemandInputs: widget.onDemandInputs);

    StreamSubscription<Map<String, dynamic>> fcmListener;
    fcmListener = FCM.onFcmMessage.listen((event) async {
      if (event['data']['type'] == 'ondemand-accepted') {
        widget.onSearchComplete();
        fcmListener.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitRing(
            color: Colours.blue,
            lineWidth: Dimensions.d_5,
          ),
          Padding(
            padding: EdgeInsets.only(top: Dimensions.d_15),
            child: Text(
              'Sedang memuatkan, sila bersabar ...',
              style: TextStyle(fontSize: FontSizes.smallerText,
                  color: Colours.grey,
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
      bottomNavigationBar: UserButton(
          text: 'Batal',
          padding: EdgeInsets.all(Dimensions.d_30),
          color: Colours.cancel,
          onClick: () {
            OnDemandServices().cancelOnDemandRequest(headerToken: _authToken);
            widget.onCancelClick();
          }),
    );
  }
}
