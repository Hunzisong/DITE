import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/home/on_demand/on_demand_user_loading_page.dart';
import 'package:heard/home/on_demand/on_demand_success.dart';
import 'package:heard/widgets/widgets.dart';

class OnDemandUserPage extends StatefulWidget {
  @override
  _OnDemandUserPageState createState() => _OnDemandUserPageState();
}

class _OnDemandUserPageState extends State<OnDemandUserPage> {
  bool loadingScreen = false;
  bool pairingComplete = false;
  OnDemandInputs onDemandInputs;

  @override
  void initState() {
    super.initState();
    onDemandInputs = OnDemandInputs();
  }

  @override
  void dispose() {
    super.dispose();
    onDemandInputs.disposeTexts();
  }

  @override
  Widget build(BuildContext context) {
    return loadingScreen
        ? OnDemandUserLoadingPage(
            onCancelClick: () {
              setState(() {
                loadingScreen = false;
              });
            },
            onSearchComplete: () {
              setState(() {
                loadingScreen = false;
                pairingComplete = true;
              });
            },
          )
        : pairingComplete
            ? OnDemandSuccessPage(
                onCancelClick: () {
                  setState(() {
                    pairingComplete = false;
                    onDemandInputs.reset();
                  });
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
                                    fontSize: FontSizes.normal)),
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
                                            Radius.circular(Dimensions.d_10))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: Dimensions.d_10,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: RadioListTile(
                                                  dense: true,
                                                  title: Text(
                                                    'Lelaki',
                                                    style: TextStyle(
                                                        fontSize: FontSizes
                                                            .smallerText),
                                                  ),
                                                  value: gender.male,
                                                  groupValue: onDemandInputs.genderType,
                                                  onChanged: (gender value) {
                                                    setState(() {
                                                      onDemandInputs.genderType = value;
                                                    });
                                                  }),
                                            ),
                                            Expanded(
                                              child: RadioListTile(
                                                  dense: true,
                                                  title: Text(
                                                    'Perempuan',
                                                    style: TextStyle(
                                                        fontSize: FontSizes
                                                            .smallerText),
                                                  ),
                                                  value: gender.female,
                                                  groupValue: onDemandInputs.genderType,
                                                  onChanged: (gender value) {
                                                    setState(() {
                                                      onDemandInputs.genderType = value;
                                                    });
                                                  }),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: Dimensions.d_25),
                                          child: InputField(
                                            controller: onDemandInputs.patientName,
                                            labelText: 'Nama Pesakit',
                                            backgroundColour: Colours.lightGrey,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: Dimensions.d_25),
                                          child: InputField(
                                            controller: onDemandInputs.noteToSLI,
                                            labelText: 'Nota kepada JBIM',
                                            backgroundColour: Colours.lightGrey,
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
                    setState(() {
                      loadingScreen = true;
                    });
                  },
                ),
              );
  }
}

class OnDemandInputs {
  TextEditingController hospital = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController patientName = TextEditingController();
  TextEditingController noteToSLI = TextEditingController();
  bool isEmergency = false;
  bool isBookingForOthers = false;
  gender genderType;

  void disposeTexts() {
    hospital.dispose();
    department.dispose();
    patientName.dispose();
    noteToSLI.dispose();
  }

  void reset() {
    hospital.clear();
    department.clear();
    patientName.clear();
    noteToSLI.clear();
    isEmergency = false;
    isBookingForOthers = false;
    genderType = null;
  }
}
