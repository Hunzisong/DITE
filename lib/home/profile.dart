import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/firebase_services/auth_service.dart';
import 'package:heard/widgets/user_button.dart';

class Profile extends StatefulWidget {
  final bool isSLI;
  final dynamic userDetails;

  Profile({this.isSLI = false, this.userDetails});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.d_35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ListTile(
            title: Text('Name: ${widget.userDetails.name}'),
            subtitle: Text('Phone Number: ${widget.userDetails.phoneNo}'),
          ),
          UserButton(
            color: widget.isSLI ? Colours.orange : Colours.blue,
            text: "Log Out",
            onClick: () => AuthService().signOut(context),
          ),
          UserButton(
            color: widget.isSLI ? Colours.orange : Colours.blue,
            text: "Delete Account",
            onClick: () {
              AuthService().deleteAndSignOut(context);
            },
          ),
        ],
      ),
    );
  }
}
