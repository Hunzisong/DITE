import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/firebase_services/auth_service.dart';
import 'package:heard/home/on_demand/on_demand_user_loading_page.dart';
import 'package:heard/home/on_demand/on_demand_success.dart';
import 'package:heard/http_services/on_demand_services.dart';
import 'package:heard/http_services/user_services.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:heard/home/on_demand/data_structure/OnDemandInputs.dart';
import 'package:heard/api/on_demand_status.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnDemandUserPage extends StatefulWidget {
  @override
  _OnDemandUserPageState createState() => _OnDemandUserPageState();
}

class _OnDemandUserPageState extends State<OnDemandUserPage>
    with AutomaticKeepAliveClientMixin {
  bool requestPending = false;
  bool pairingComplete = false;
  bool loadingScreen = true;
  String authToken;
  OnDemandInputs onDemandInputs;
  OnDemandStatus onDemandStatus;
  final fieldsIncompleteSnackBar = SnackBar(content: Text('Fields incomplete'));
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    onDemandInputs = OnDemandInputs();
    (() async {
      prefs = await SharedPreferences.getInstance();
    })();
    getOnDemandStatus().whenComplete(() {
      setState(() {
        loadingScreen = false;
      });
      if (onDemandStatus.toJson()["status"] == "ongoing") {
        prefs.setBool("userOnDemandOngoing", true);
        prefs.setBool("userOnDemandPending", false);
        setState(() {
          requestPending = false;
          pairingComplete = true;
        });
      } else if (onDemandStatus.toJson()["status"] == "pending") {
        prefs.setBool("userOnDemandOngoing", false);
        prefs.setBool("userOnDemandPending", true);
        setState(() {
          requestPending = true;
          pairingComplete = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    onDemandInputs.disposeTexts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (prefs != null) {
      if (pairingComplete != prefs.getBool("userOnDemandOngoing") && prefs.containsKey("userOnDemandOngoing")) {
        setState(() {
          pairingComplete = prefs.getBool("userOnDemandOngoing");
        });
      }
      if (requestPending != prefs.getBool("userOnDemandPending") && prefs.containsKey("userOnDemandPending")) {
        setState(() {
          requestPending = prefs.getBool("userOnDemandPending");
        });
      }
    }

    return loadingScreen
        ? Scaffold(
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
                    style: TextStyle(
                        fontSize: FontSizes.smallerText,
                        color: Colours.grey,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          )
        : pairingComplete
          ? OnDemandSuccessPage(
              isSLI: false,
              onDemandStatus: onDemandStatus,
              onCancelClick: () {
                setState(() {
                  pairingComplete = false;
                  onDemandInputs.reset();
                });
                prefs.setBool("userOnDemandOngoing", false);
              },
            )
          : requestPending
            ? OnDemandUserLoadingPage(
              onDemandInputs: onDemandInputs,
              onCancelClick: () {
                setState(() {
                  requestPending = false;
                });
                prefs.setBool("userOnDemandPending", false);
              },
              onSearchComplete: () async {
                await getOnDemandStatus();
                setState(() {
                  requestPending = false;
                  pairingComplete = true;
                });
                prefs.setBool("userOnDemandPending", false);
                prefs.setBool("userOnDemandOngoing", true);
              },
            )
                : Scaffold(
                    backgroundColor: Colours.white,
                    body: ListView(
                      children: <Widget>[
                        Padding(
                          padding: Paddings.signUpPage,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                contentPadding: EdgeInsets.all(Dimensions.d_0),
                                title: Text('Servis permintaan segera:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: FontSizes.biggerText)),
                                subtitle: Text(
                                  'Cari JBIM dan mulakan video call sekarang.',
                                  style: TextStyle(
                                      fontSize: FontSizes.normal,
                                      color: Colours.darkGrey),
                                ),
                              ),
                              InputField(
                                controller: onDemandInputs.hospital,
                                labelText: 'Nama Hospital',
                              ),
                              InputField(
                                controller: onDemandInputs.department,
                                labelText: 'Jabatan Hospital',
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: Dimensions.d_15),
                                child: Row(children: [
                                  Text(
                                    'Jantina Pilihan JBIM',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ]),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(bottom: Dimensions.d_5),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 20,
                                      child: RadioListTile(
                                          dense: true,
                                          title: Text(
                                            'Lelaki',
                                            style: TextStyle(
                                                fontSize:
                                                    FontSizes.smallerText),
                                          ),
                                          value: Gender.male,
                                          groupValue: onDemandInputs.genderType,
                                          onChanged: (Gender value) {
                                            setState(() {
                                              onDemandInputs.genderType = value;
                                            });
                                          }),
                                    ),
                                    Expanded(
                                      flex: 26,
                                      child: RadioListTile(
                                          dense: true,
                                          title: Text(
                                            'Perempuan',
                                            style: TextStyle(
                                                fontSize:
                                                    FontSizes.smallerText),
                                          ),
                                          value: Gender.female,
                                          groupValue: onDemandInputs.genderType,
                                          onChanged: (Gender value) {
                                            setState(() {
                                              onDemandInputs.genderType = value;
                                            });
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              CheckBoxTile(
                                value: onDemandInputs.isEmergency,
                                onChanged: (bool value) {
                                  setState(() {
                                    onDemandInputs.isEmergency = value;
                                  });
                                },
                                text: 'Kecemasan﻿',
                              ),
                              CheckBoxTile(
                                value: onDemandInputs.isBookingForOthers,
                                onChanged: (bool value) {
                                  setState(() {
                                    onDemandInputs.isBookingForOthers = value;
                                  });
                                },
                                text:
                                    'Saya mem﻿inta perkhidmatan JBIM bagi pihak orang lain',
                              ),
                              onDemandInputs.isBookingForOthers
                                  ? Padding(
                                      padding:
                                          EdgeInsets.only(top: Dimensions.d_15),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colours.lightGrey,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    Dimensions.d_10))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              height: Dimensions.d_10,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Dimensions.d_25),
                                              child: InputField(
                                                controller:
                                                    onDemandInputs.patientName,
                                                labelText: 'Nama Pesakit',
                                                backgroundColour:
                                                    Colours.lightGrey,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Dimensions.d_25),
                                              child: InputField(
                                                controller:
                                                    onDemandInputs.noteToSLI,
                                                labelText: 'Nota kepada JBIM',
                                                backgroundColour:
                                                    Colours.lightGrey,
                                                moreLines: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox.shrink()
                            ],
                          ),
                        ),
                      ],
                    ),
                    bottomNavigationBar: UserButton(
                      text: 'Carian',
                      padding: EdgeInsets.all(Dimensions.d_30),
                      color: Colours.blue,
                      onClick: () {
                        if (allFieldsFilled()) {
                          setState(() {
                            requestPending = true;
                          });
                          prefs.setBool("userOnDemandPending", true);
                        } else {
                          Scaffold.of(context)
                              .showSnackBar(fieldsIncompleteSnackBar);
                        }
                      },
                    ),
                  );
  }

  bool allFieldsFilled() {
    if (onDemandInputs.hospital.text.isNotEmpty &&
        onDemandInputs.department.text.isNotEmpty &&
        onDemandInputs.genderType != null) {
      if ((onDemandInputs.isBookingForOthers == false) ||
          (onDemandInputs.isBookingForOthers == true &&
              onDemandInputs.patientName.text.isNotEmpty)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> getOnDemandStatus() async {
    String _authToken = await AuthService.getToken();
    OnDemandStatus _onDemandStatus = await OnDemandServices()
        .getOnDemandStatus(isSLI: false, headerToken: _authToken);
    setState(() {
      onDemandStatus = _onDemandStatus;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
