import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/firebase_services/auth_service.dart';
import 'package:heard/widgets/user_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Profile extends StatefulWidget {
  final dynamic userDetails;

  Profile({this.userDetails});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  bool isSLI;
  bool showLoadingAnimation = false;

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                                trailing: Text('${widget.userDetails.name}'),
                                onTap: () {
                                  print('tapped');
                                  },
                              ),
                            ),
                            Divider(
                              height: Dimensions.d_0,
                              thickness: Dimensions.d_3,
                              color: Colours.lightGrey,
                            ),
                            ListTile(
                              title: Text('Jantina'),
                              trailing: Text('${widget.userDetails.gender}'),
                              onTap: () {print('tapped');},
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: Dimensions.d_35),
                        child: Icon(
                          Icons.account_circle,
                          size: Dimensions.d_140,
                          color: Colours.darkGrey,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(left: Dimensions.d_100, top: Dimensions.d_120),
                        child: CircleAvatar(
                          backgroundColor: isSLI ? Colours.orange : Colours.blue,
                          radius: Dimensions.d_25,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ),
                    // isSLI
                    //     ?
                    //     Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: <Widget>[
                    //           Text('Name: ${widget.userDetails.name.text}'),
                    //           Text('Phone Number: ${widget.userDetails.phoneNo}'),
                    //           // Text('Gender: ${widget.userDetails.gender}'),
                    //           // Text(
                    //           //     'Medical Experience: ${widget.userDetails.experiencedMedical}'),
                    //           // Text(
                    //           //     'Fluency: ${widget.userDetails.experiencedBim}'),
                    //           // Text('Medical Years: ${widget.userDetails.yearsMedical}'),
                    //           // Text('BIM Years: ${widget.userDetails.yearsBim}'),
                    //         ],
                    //       )
                    //     : Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: <Widget>[
                    //           Text('Name: ${widget.userDetails.name}'),
                    //           Text('Phone Number: ${widget.userDetails.phoneNo}'),
                    //           Text('Gender: ${widget.userDetails.gender}'),
                    //           Text('Age: ${widget.userDetails.age}'),
                    //         ],
                    //       ),
                    Padding(
                      padding: EdgeInsets.only(top: Dimensions.d_100 * 3.5),
                      child: UserButton(
                          color: isSLI ? Colours.orange : Colours.blue,
                          text: "Log Out",
                          onClick: () {
                            setState(() {
                              showLoadingAnimation = true;
                            });
                            AuthService().signOut(context);
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Dimensions.d_100 * 4.3),
                      child: UserButton(
                        color: isSLI ? Colours.orange : Colours.blue,
                        text: "Delete Account",
                        onClick: () {
                          setState(() {
                            showLoadingAnimation = true;
                          });
                          AuthService().deleteAndSignOut(context: context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      // bottomNavigationBar: UserButton(
      //   color: isSLI ? Colours.orange : Colours.blue,
      //   text: "Delete Account",
      //   onClick: () {
      //     setState(() {
      //       showLoadingAnimation = true;
      //     });
      //     AuthService().deleteAndSignOut(context: context);
      //   },
      // ),
        );
  }

  @override
  bool get wantKeepAlive => true;
}
