import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/widgets/widgets.dart';


class UserBookingResultPage extends StatefulWidget {
  @override
  _UserBookingResultPageState createState() => _UserBookingResultPageState();
}

class _UserBookingResultPageState extends State<UserBookingResultPage> {

  List <DropdownMenuItem <String>> genderList ;
  String selectedGender;

  List <DropdownMenuItem <String>> experienceList ;
  String selectedExperience;

  void loadGenderList(){

    genderList=[];
    genderList.add(new DropdownMenuItem(
      child: new Text ('Lelaki'),
      value: 'male',
    ));

    genderList.add(new DropdownMenuItem(
      child: new Text ('Perempuan'),
      value: "female",
    ));
  }

  void loadExperienceList(){

    experienceList=[];
    experienceList.add(new DropdownMenuItem(
      child: new Text ('1'),
      value: 'one',
    ));

    experienceList.add(new DropdownMenuItem(
      child: new Text ('2'),
      value: "two",
    ));
  }

  @override
  Widget build(BuildContext context) {
    loadGenderList();
    loadExperienceList();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colours.white,
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(Dimensions.d_30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height:Dimensions.d_45,
                          child: DropdownList(
                            hintText: "Jantina",
                            selectedItem: selectedGender,
                            itemList: genderList,
                            onChanged: (value){
                              setState(() {
                                selectedGender= value;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: Dimensions.d_10),
                      Expanded(
                        child: Container(
                          height:Dimensions.d_45,
                          child: DropdownList(
                            hintText: "Pengalaman",
                            selectedItem: selectedExperience,
                            itemList: experienceList,
                            onChanged: (value){
                              setState(() {
                                selectedExperience= value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.d_20),
                  Text(
                    "Something.."
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
