import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:heard/constants.dart';
import 'package:heard/home/on_demand/on_demand_success.dart';
import 'package:heard/widgets/slidable_list_tile.dart';
import 'package:heard/widgets/widgets.dart';

class OnDemandSLIPage extends StatefulWidget {
  @override
  _OnDemandSLIPageState createState() => _OnDemandSLIPageState();
}

class _OnDemandSLIPageState extends State<OnDemandSLIPage> {
  bool pairingComplete = false;

  List<UserInfoTemp> mockInfoList = [
    UserInfoTemp().addInfo(
        name: 'James Cooper',
        hospital: 'Hospital Sg Buloh',
        department: 'Jabatan Jantung',
        messageToSLI: 'Jangan pakai baju warna merah jambu',
        isEmergency: true),
    UserInfoTemp().addInfo(
        name: 'Kyle Jenner',
        hospital: 'Hospital Sg Long',
        department: 'Jabatan Tangan',
        isEmergency: true),
    UserInfoTemp().addInfo(
        name: 'Kim Possible',
        hospital: 'Hospital Sarawak',
        department: 'Jabatan Rambut',
        messageToSLI: 'Jangan pakai baju warna merah'),
    UserInfoTemp().addInfo(
        name: 'Arthur Knight',
        hospital: 'Hospital Kuala Lumpur',
        department: 'Jabatan Telinga'),
    UserInfoTemp().addInfo(
        name: 'John Monash',
        hospital: 'Hospital Selangor',
        department: 'Jabatan Muka'),
    UserInfoTemp().addInfo(
        name: 'Michael Lee',
        hospital: 'Hospital Pahang',
        department: 'Jabatan Mata'),
    UserInfoTemp().addInfo(
        name: 'Takashi Hiro',
        hospital: 'Hospital Sabah',
        department: 'Jabatan Kaki'),
    UserInfoTemp().addInfo(
        name: 'James Cooper',
        hospital: 'Hospital Pulau Pinang',
        department: 'Jabatan Mulut'),
    UserInfoTemp().addInfo(
        name: 'James Cooper',
        hospital: 'Hospital Seremban',
        department: 'Jabatan Arteri'),
    UserInfoTemp().addInfo(
        name: 'James Cooper',
        hospital: 'Hospital Shah Alam',
        department: 'Jabatan Badan'),
  ];

  @override
  Widget build(BuildContext context) {
    return pairingComplete
        ? OnDemandSuccessPage(
            isSLI: true,
            onCancelClick: () {
              setState(() {
                pairingComplete = false;
              });
            },
          )
        : Scaffold(
            backgroundColor: Colours.white,
            body: ListView(
              children: <Widget>[
                Container(
                  color: Colours.grey,
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.d_20, vertical: Dimensions.d_10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Permintaan Aktif',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '*Leret ke kiri untuk pengesahan',
                        style: TextStyle(
                            fontSize: Dimensions.d_10,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  controller: ScrollController(),
                  shrinkWrap: true,
                  itemCount: mockInfoList.length,
                  itemBuilder: (context, index) {
                    return SlidableListTile(
                      isThreeLine: true,
                      userInfo: mockInfoList[index],
                      onAccept: () {
                        popUpDialog(
                            context: context,
                            isSLI: true,
                            header: 'Pengesahan',
                            content: Padding(
                              padding: EdgeInsets.symmetric(vertical: Dimensions.d_45),
                              child: Text(
                                'Adakah anda pasti?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colours.darkGrey,
                                fontSize: FontSizes.normal),
                              ),
                            ),
                            buttonText: 'Teruskan',
                            onClick: () {
                              Navigator.pop(context);
                              setState(() {
                                pairingComplete = true;
                              });
                            });
                      },
                      onTrailingButtonPress: IconButton(
                        icon: Icon(Icons.info_outline),
                        color: Colours.orange,
                        iconSize: Dimensions.d_30,
                        onPressed: () {
                          popUpDialog(
                            context: context,
                            isSLI: true,
                            height: Dimensions.d_130 * 3.5,
                            onClick: () {
                              Navigator.pop(context);
                            },
                            header: 'Maklumat',
                            content: Column(
                              children: <Widget>[
                                ListTile(
                                  contentPadding: EdgeInsets.all(Dimensions.d_20),
                                  isThreeLine: true,
                                  leading: Icon(
                                    Icons.account_circle,
                                    size: Dimensions.d_55,
                                  ),
                                  title: Text(
                                    '${mockInfoList[index].userName}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${mockInfoList[index].hospital}',
                                        style: TextStyle(color: Colours.darkGrey),
                                      ),
                                      Text(
                                        '(${mockInfoList[index].department})',
                                        style: TextStyle(color: Colours.darkGrey),
                                      ),
                                      mockInfoList[index].isEmergency
                                          ? Text(
                                              '*Kecemasan',
                                              style: TextStyle(color: Colours.fail),
                                            )
                                          : SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                  EdgeInsets.symmetric(vertical: Dimensions.d_15),
                                  child: Container(
                                    height: Dimensions.d_130,
                                    decoration: BoxDecoration(
                                        color: Colours.lightGrey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(Dimensions.d_10))),
                                    child: ListTile(
                                      title: Text(mockInfoList[index].messageToSLI, style: TextStyle(fontSize: FontSizes.smallerText),),
                                    )
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          );
  }
}

class UserInfoTemp {
  String userName;
  String hospital;
  String department;
  String messageToSLI;
  bool isEmergency;

  UserInfoTemp addInfo(
      {@required String name,
      @required String hospital,
      @required String department,
      String messageToSLI = '',
      bool isEmergency = false}) {
    UserInfoTemp newPerson = UserInfoTemp();
    newPerson.userName = name;
    newPerson.hospital = hospital;
    newPerson.department = department;
    newPerson.messageToSLI = messageToSLI;
    newPerson.isEmergency = isEmergency;

    return newPerson;
  }
}
