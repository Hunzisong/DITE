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

class _ProfileState extends State<Profile> {
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
    return isSLI == null ? Container() : ModalProgressHUD(
      inAsyncCall: showLoadingAnimation,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.d_35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            isSLI ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Name: ${widget.userDetails.name}'),
                Text('Phone Number: ${widget.userDetails.phoneNo}'),
                Text('Gender: ${widget.userDetails.gender}'),
                Text('Medical Experience: ${widget.userDetails.experiencedMedical}'),
                Text('Fluency: ${widget.userDetails.experiencedBim}'),
              ],
            ) : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Name: ${widget.userDetails.name}'),
                Text('Phone Number: ${widget.userDetails.phoneNo}'),
              ],
            ),
            UserButton(
              color: isSLI ? Colours.orange : Colours.blue,
              text: "Log Out",
              onClick: () {
                setState(() {
                  showLoadingAnimation = true;
                });
                AuthService().signOut(context);
              }
            ),
            UserButton(
              color: isSLI ? Colours.orange : Colours.blue,
              text: "Delete Account",
              onClick: () {
                setState(() {
                  showLoadingAnimation = true;
                });
                AuthService().deleteAndSignOut(context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
