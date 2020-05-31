import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/widgets/widgets.dart';

class OnDemandSuccessPage extends StatelessWidget {
  final Function onCancelClick;
  final AssetImage profilePic;
  final String name;
  final String gender;
  final String age;

  final double paddingLR = Dimensions.d_20;

  OnDemandSuccessPage({this.onCancelClick, this.profilePic, this.name, this.gender, this.age});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: Paddings.horizontal_20,
        child: Column(
          children: <Widget>[
            SizedBox(height: Dimensions.d_15),
            Row(
              children: <Widget>[
                SizedBox(
                  height: Dimensions.d_25,
                  child: Hero(
                      tag: 'success',
                      child: Image(
                          image: AssetImage('images/successTick.png')
                      )
                  ),
                ),
                SizedBox(
                  width: Dimensions.d_10,
                ),
                Text(
                  "Berpasangan dilengkapkan",
                  style: TextStyle(color: Colors.green)
                )
              ]
            ),
            SizedBox(height: Dimensions.d_20),
            SizedBox(
              height: Dimensions.d_100,
              child: Hero(
                  tag: 'success',
                  child: Image(
                      image: this.profilePic ?? AssetImage('images/avatar.png')
                  )
              ),
            ),
            SizedBox(height: Dimensions.d_15),
            Text(
              "${this.name ?? "Adam Tan"}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.d_25)
            ),
            SizedBox(height: Dimensions.d_15),
            Container(
              width: MediaQuery.of(context).size.width - paddingLR * 2,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: Dimensions.d_130,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Jantina : ${this.gender ?? "Lelaki"}"),
                      )
                    ),
                    SizedBox(height: Dimensions.d_5),
                    Container(
                        width: Dimensions.d_130,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Umur     : ${this.age ?? "32"}"),
                        )
                    ),
                    SizedBox(height: Dimensions.d_15),
                  ],
                )
              )
            ),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.5, color: Colours.grey),
                    bottom: BorderSide(width: 1.5, color: Colours.grey)
                  )
                ),
                child: Padding(
                  padding: Paddings.vertical_5,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        height: Dimensions.d_65,
                        width: MediaQuery.of(context).size.width / 2 - paddingLR,
                        child: InkWell(
                          onTap: onTapMessage,
                          child: Image(
                              image: AssetImage('images/message.png')
                          )
                        )
                      ),
                      SizedBox(
                        height: Dimensions.d_65,
                        width: MediaQuery.of(context).size.width / 2 - paddingLR,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(width: 1.5, color: Colours.grey)
                              )
                          ),
                          child: InkWell(
                            onTap: onTapVideo,
                            child: Image(
                                image: AssetImage('images/video.png')
                            )
                          )
                        )
                      ),
                    ],
                  )
                )
              )
            )
          ],
        )
      ),
      bottomNavigationBar: UserButton(
        text: 'Batal Berpasangan',
        padding: EdgeInsets.all(Dimensions.d_30),
        color: Colours.cancel,
        onClick: () {
          onCancelClick();
        }),
    );
  }

  void onTapMessage(){debugPrint("Message is tapped");}
  void onTapVideo(){debugPrint("Video is tapped");}
}