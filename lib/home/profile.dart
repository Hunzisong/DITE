import 'package:flutter/material.dart';
import 'package:heard/api/user.dart';
import 'package:heard/constants.dart';
import 'package:heard/firebase_services/auth_service.dart';
import 'package:heard/http_services/sli_services.dart';
import 'package:heard/http_services/user_services.dart';
import 'package:heard/widgets/user_button.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final User userDetails;

  Profile({this.userDetails});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  bool isSLI;
  User userDetails;
  List <DropdownMenuItem<String>> genderOptions;
  List <DropdownMenuItem<String>> yearsBimOptions;
  List <DropdownMenuItem<String>> yearsMedicalOptions;

  @override
  void initState() {
    super.initState();
    setSLI();
  }

  void setSLI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isSLI = preferences.getBool('isSLI');
    });
  }

  void initialize() {
    genderOptions=[];
    genderOptions.add(DropdownMenuItem(
      child: Text('Lelaki'),
      value: 'male',
    ));
    genderOptions.add(DropdownMenuItem(
        child: Text('Perempuan'),
      value: 'female',
    ));

    yearsBimOptions = [];
    yearsMedicalOptions = [];
    for (int i = 0; i < 51; i++) {
      yearsBimOptions.add(DropdownMenuItem(
        child: Text('$i Tahun'),
        value: i.toString(),
      ));
      yearsMedicalOptions.add(DropdownMenuItem(
        child: Text('$i Tahun'),
        value: i.toString(),
      ));
    }
  }

  void showLoadingAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<void> editDetails({String key, dynamic value}) async {
    showLoadingAnimation();
    String authTokenString = await AuthService.getToken();
    isSLI ? await SLIServices().editSLI(headerToken: authTokenString, key: key, value: value) : await UserServices().editUser(headerToken: authTokenString, key: key, value: value);
    User userDetailsTest = isSLI ? await SLIServices().getSLI(headerToken: authTokenString) : await UserServices().getUser(headerToken: authTokenString);
    Navigator.pop(context);

    setState(() {
    userDetails = userDetailsTest;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (userDetails == null && genderOptions == null) {
      userDetails = widget.userDetails;
      initialize();
    }
    return isSLI == null
        ? Container()
        : Scaffold(
          backgroundColor: Colours.white,
          body: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: Dimensions.d_25),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: Dimensions.d_85 * 2,
                      color: isSLI ? Colours.lightOrange : Colours.lightBlue,
                    ),
                    Card(
                      margin: EdgeInsets.only(left: Dimensions.d_25, right: Dimensions.d_25, top: Dimensions.d_100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimensions.d_10),
                      ),
                      elevation: Dimensions.d_5,
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.d_20),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: Dimensions.d_65),
                              child: ListTile(
                                title: Text('Nama'),
                                trailing: Text('${userDetails.name.text}', style: TextStyle(fontSize: FontSizes.normal),),
                                onTap: () {
                                  print('tapped ${userDetails.age}');
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext alertContext) {
                                      return AlertDialog(
                                        title: Text('Tukar Nama'),
                                        content: InputField(
                                          controller: userDetails.name,
                                          labelText: 'Nama Baru',
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Tukar'),
                                            onPressed: () async {
                                              Navigator.of(alertContext).pop();
                                              editDetails(key: 'name', value: userDetails.name.text);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  },
                              ),
                            ),
                            Divider(
                              height: Dimensions.d_0,
                              thickness: Dimensions.d_3,
                              color: Colours.lightGrey,
                            ),
                            Stack(
                              children: [
                                ListTile(
                                  title: Text('Jantina'),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: Dimensions.d_85 * 2.2, top: Dimensions.d_2*2.3),
                                  child: DropdownList(
                                    noColour: true,
                                    padding: EdgeInsets.all(0),
                                    hintText: userDetails.gender,
                                    selectedItem: userDetails.gender,
                                    itemList: genderOptions,
                                    onChanged: (value) async {
                                      editDetails(key: 'gender', value: value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            !isSLI ? Column(
                              children: [
                                Divider(
                                  height: Dimensions.d_0,
                                  thickness: Dimensions.d_3,
                                  color: Colours.lightGrey,
                                ),
                                ListTile(
                                  title: Text('Umur'),
                                  trailing: Text('${userDetails.age ?? ''}', style: TextStyle(fontSize: FontSizes.normal),),
                                ),
                              ],
                            ) : Column(
                              children: [
                                Divider(
                                  height: Dimensions.d_0,
                                  thickness: Dimensions.d_3,
                                  color: Colours.lightGrey,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Dimensions.d_10),
                                  child: Stack(
                                    children: [
                                      ListTile(
                                        title: Text('Pengalaman Menterjemah'),
                                        trailing: SizedBox(
                                          width: Dimensions.d_130,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: Dimensions.d_85 * 2.55, top: Dimensions.d_2*2.3),
                                        child: DropdownList(
                                          noColour: true,
                                          padding: EdgeInsets.all(0),
                                          hintText: userDetails.years_bim.toString(),
                                          selectedItem: userDetails.years_bim.toString(),
                                          itemList: yearsBimOptions,
                                          onChanged: (value) async {
                                            editDetails(key: 'years_bim', value: value);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: Dimensions.d_0,
                                  thickness: Dimensions.d_3,
                                  color: Colours.lightGrey,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Dimensions.d_10),
                                  child: Stack(
                                    children: [
                                      ListTile(
                                        title: Text('Pengalaman Dalam Bidang Perubatan'),
                                        trailing: SizedBox(
                                          width: Dimensions.d_130,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: Dimensions.d_85 * 2.55, top: Dimensions.d_2*2.3),
                                        child: DropdownList(
                                          noColour: true,
                                          padding: EdgeInsets.all(0),
                                          hintText: userDetails.years_medical.toString(),
                                          selectedItem: userDetails.years_medical.toString(),
                                          itemList: yearsMedicalOptions,
                                          onChanged: (value) async {
                                            editDetails(key: 'years_medical', value: value);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: Dimensions.d_35),
                        child: CircleAvatar(
                          backgroundColor: Colours.lightGrey,
                          radius: Dimensions.d_65,
                          child: Icon(
                            Icons.account_circle,
                            size: Dimensions.d_130,
                            color: Colours.darkGrey,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(left: Dimensions.d_100, top: Dimensions.d_120),
                        child: GestureDetector(
                          onTap: () {
                            print('tapped!');
                          },
                          child: CircleAvatar(
                            backgroundColor: isSLI ? Colours.orange : Colours.blue,
                            radius: Dimensions.d_20,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.d_20),
                child: Column(
                  children: [
                    UserButton(
                        color: isSLI ? Colours.orange : Colours.blue,
                        text: "Log Out",
                        onClick: () async {
                          showLoadingAnimation();
                          await AuthService().signOut(context);
                          Navigator.pop(context);
                        }),
                    UserButton(
                      color: isSLI ? Colours.orange : Colours.blue,
                      text: "Delete Account",
                      onClick: () async {
                        showLoadingAnimation();
                        await AuthService().deleteAndSignOut(context: context);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
  }

  @override
  bool get wantKeepAlive => true;
}
