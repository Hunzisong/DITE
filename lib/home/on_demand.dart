import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/video_chat_components/index.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class OnDemand extends StatefulWidget {
  @override
  _OnDemandState createState() => _OnDemandState();
}

class _OnDemandState extends State<OnDemand> {
  bool showLoadingAnimation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.white,
      body: ModalProgressHUD(
        inAsyncCall: showLoadingAnimation,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: Paddings.startupMain,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: Dimensions.d_280,
                    child: Image(
                      image: AssetImage('images/onDemand.png'),
                    ),
                  ),
                  SizedBox(height: Dimensions.d_15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Servis on-demand:',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: FontSizes.normal)),
                        Text('Cari JBIM dan mulakan video call sekarang.',
                          style: TextStyle(fontSize: FontSizes.normal),)
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.d_65),
                  UserButton(
                    text: 'Carian',
                    color: Colours.blue,
                    onClick: () async {
                      setState(() {
                        showLoadingAnimation = true;
                        Navigator.push(
                          context,
                          // move to the video call page
                          MaterialPageRoute(builder: (context) => IndexPage()),
                        );
                        showLoadingAnimation = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}