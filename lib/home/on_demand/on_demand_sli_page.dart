import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:heard/constants.dart';
import 'package:heard/widgets/slidable_list_tile.dart';
import 'package:heard/widgets/widgets.dart';

class OnDemandSLIPage extends StatefulWidget {
  @override
  _OnDemandSLIPageState createState() => _OnDemandSLIPageState();
}

class _OnDemandSLIPageState extends State<OnDemandSLIPage> {
  bool pairingComplete = false;
  List<String> mockNameList = [
    'James Cooper',
    'Daniel James',
    'Kyle Jenner',
    'Kim Possible',
    'Arthur Knight',
    'John Monash',
    'Michael Lee',
    'Takashi Hiro',
    'Jerry Tomson'
  ];

  @override
  Widget build(BuildContext context) {
    return pairingComplete
        /// TODO: Replace Container with finished page afterwards
        ? Center(
            child: Text('Pairing Complete'),
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
                  itemCount: mockNameList.length,
                  itemBuilder: (context, index) {
                    return SlidableListTile(
                      name: mockNameList[index],
                      onTap: () {
                        createDialog(context: context,
                        onAcceptClick: () {
                          setState(() {
                            pairingComplete = true;
                          });
                        });
                      },
                    );
                  },
                )
              ],
            ),
          );
  }
}

Future<dynamic> createDialog({BuildContext context, Function onAcceptClick}) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: Dimensions.d_280,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.d_15, horizontal: Dimensions.d_30),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: Paddings.vertical_5,
                    child: Text(
                      "Pengesahan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: FontSizes.mainTitle,
                          color: Colours.darkGrey),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.d_65,
                  ),
                  Padding(
                    padding: Paddings.horizontal_5,
                    child: Text(
                      'Adakah anda pasti?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: FontSizes.biggerText,
                          color: Colours.darkGrey),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.d_45,
                  ),
                  UserButton(
                    text: 'Teruskan',
                    color: Colours.orange,
                    onClick: () {
                      // Popping all previous pages of the application before proceeding to verification page
                      Navigator.pop(context);
                      onAcceptClick();
                    },
                  )
                ],
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(Dimensions.d_10))),
          elevation: Dimensions.d_15,
        );
      });
}
