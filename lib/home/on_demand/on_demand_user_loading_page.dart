import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:heard/api/user.dart';
import 'package:heard/constants.dart';
import 'package:heard/firebase_services/auth_service.dart';
import 'package:heard/firebase_services/fcm.dart';
import 'package:heard/widgets/loading_screen.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:heard/http_services/on_demand_services.dart';
import 'package:heard/home/on_demand/data_structure/OnDemandInputs.dart';
import 'package:heard/http_services/user_services.dart';

class OnDemandUserLoadingPage extends StatefulWidget {
  OnDemandUserLoadingPage(
      {Key key,
      @required this.onCancelClick,
      @required this.onSearchComplete,
      @required this.onDemandInputs,
      this.reNavigation = false})
      : super(key: key);
  final Function onCancelClick;
  final Function onSearchComplete;
  final OnDemandInputs onDemandInputs;
  final bool reNavigation;

  @override
  OnDemandUserLoadingPageState createState() =>
      new OnDemandUserLoadingPageState();
}

class OnDemandUserLoadingPageState extends State<OnDemandUserLoadingPage> {
  String _authToken;
  int _countdownValue = 60;
  Timer _countdownTimer;
  Widget inputs;

  @override
  void initState() {
    super.initState();
    setState(() {
      inputs = Column(children: [
        Text('Nama Hospital: ${widget.onDemandInputs.hospital.text}'),
        Text('Jabatan Hospital: ${widget.onDemandInputs.department.text}'),
        Text('Jantina: ${widget.onDemandInputs.genderType.toString().split('.').last == 'male' ? 'Lelaki' : 'Perempuan'}'),
        Text('Kecemasan: ${widget.onDemandInputs.isEmergency ? 'Ya' : 'Tidak'}'),
        Text('Permintaan bagi orang lain: ${widget.onDemandInputs.isBookingForOthers ? 'Ya' : 'Tidak'}')
      ]);
    });
    getAuthToken().whenComplete(() {
      if (!widget.reNavigation) {
        onDemandRequest();
      }
      subscribeFCMListener();
      startTimer();
    });
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _countdownTimer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_countdownValue < 1) {
            OnDemandServices().cancelOnDemandRequest(headerToken: _authToken);
            widget.onCancelClick(message: "No response to request");
          } else {
            _countdownValue = _countdownValue - 1;
          }
        },
      ),
    );
  }

  Future<void> getAuthToken() async {
    String _authTokenString = await AuthService.getToken();
    setState(() {
      _authToken = _authTokenString;
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  void subscribeFCMListener() {
    StreamSubscription<Map<String, dynamic>> fcmListener;
    fcmListener = FCM.onFcmMessage.listen((event) async {
      if (event['data']['type'] == 'ondemand-accepted') {
        widget.onSearchComplete();
        fcmListener.cancel();
      }
    });
  }

  void onDemandRequest() async {
    await getAuthToken();
    if (widget.onDemandInputs.patientName.text.isEmpty) {
      User _user = await UserServices().getUser(headerToken: _authToken);
      String _username = _user.name.text;
      widget.onDemandInputs.patientName =
          TextEditingController.fromValue(TextEditingValue(text: _username));
    }
    await OnDemandServices().makeOnDemandRequest(
        headerToken: _authToken, onDemandInputs: widget.onDemandInputs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.white,
      body: LoadingScreen(topWidget: inputs),
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
