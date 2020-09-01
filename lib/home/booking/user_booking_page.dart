import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/widgets/widgets.dart';

class UserBookingPage extends StatefulWidget {
  @override
  _UserBookingPageState createState() => _UserBookingPageState();
}

class _UserBookingPageState extends State<UserBookingPage> {

  List <DropdownMenuItem <String>> languageList = [];
  String selectedLanguage;

  List <DropdownMenuItem <String>> clinicList = [];
  String selectedClinic;

  void loadLanguageList(){

    languageList=[];
    languageList.add(new DropdownMenuItem(
      child: new Text ('Bahasa Malaysia'),
      value: 'bm',
    ));

    languageList.add(new DropdownMenuItem(
      child: new Text ('English'),
      value: "eng",
    ));
  }

  void loadClinicList(){

    clinicList=[];
    clinicList.add(new DropdownMenuItem(
      child: new Text ('Klinik Ria'),
      value: 'clinic1',
    ));

    clinicList.add(new DropdownMenuItem(
      child: new Text ('Hospital Sunway'),
      value: "hospital1",
    ));
  }
  @override
  Widget build(BuildContext context) {
    loadLanguageList();
    loadClinicList();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colours.white,
        body: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: Dimensions.d_160,
                  child: Image(
                      image: AssetImage('images/booking_calendar.png')
                  ),
                ),
                SizedBox(
                  height: Dimensions.d_15,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(Dimensions.d_0,Dimensions.d_0,Dimensions.d_140,Dimensions.d_0),
                  child: Text(
                    "Tarikh Temu Janji",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: FontSizes.normal,
                        color: Colours.darkGrey),
                  ),
                ),
                SizedBox(
                  height: Dimensions.d_5,
                ),
                _datePickerField(),
                SizedBox(
                  height: Dimensions.d_5,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(Dimensions.d_0,Dimensions.d_0,Dimensions.d_140,Dimensions.d_0),
                  child: Text(
                    "Masa Temu Janji",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: FontSizes.normal,
                        color: Colours.darkGrey),
                  ),
                ),
                SizedBox(
                  height: Dimensions.d_5,
                ),
                _timePickerField(),
                Padding(
                  padding: EdgeInsets.fromLTRB(Dimensions.d_0,Dimensions.d_0,Dimensions.d_160,Dimensions.d_0),
                  child: Text(
                    "Pilihan Bahasa",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: FontSizes.normal,
                        color: Colours.darkGrey),
                  ),
                ),
                SizedBox(
                  height: Dimensions.d_5,
                ),
                Container(
                  color: Colours.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.d_95, vertical: Dimensions.d_5),
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton(
                        value: selectedLanguage,
                        items: languageList,
                        hint: new Text('Bahasa Malaysia'),
                        iconSize: Dimensions.d_45,
                        onChanged: (value){
                          selectedLanguage= value;
                          setState(() {
                          });
                        }),
                  ),
                ),
                SizedBox(
                  height: Dimensions.d_5,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(Dimensions.d_0,Dimensions.d_0,Dimensions.d_100,Dimensions.d_0),
                  child: Text(
                    "Nama Hospital/ Klinik",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: FontSizes.normal,
                        color: Colours.darkGrey),
                  ),
                ),
                SizedBox(
                  height: Dimensions.d_5,
                ),
                Container(
                  color: Colours.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.d_95, vertical: Dimensions.d_5),
                  //margin: EdgeInsets.fromLTRB(Dimensions.d_0,Dimensions.d_0,Dimensions.d_100,Dimensions.d_0),
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton(
                        value: selectedClinic,
                        items: clinicList,
                        hint: new Text('Klinik A'),
                        iconSize: Dimensions.d_45,
                        onChanged: (value){
                          selectedClinic= value;
                          setState(() {
                          });
                        }),
                  ),
                ),
                SizedBox(
                  height: Dimensions.d_45,
                ),
                UserButton(
                  text: 'Carian',
                  padding: EdgeInsets.all(Dimensions.d_30),
                  color: Colours.blue,
                  onClick: (){},
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}


Widget _datePickerField() {
  return StatefulBuilder(builder: (context, setState) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.d_10),
      child: Container(
        color: Colours.lightBlue,
        padding: EdgeInsets.all(Dimensions.d_0),
        margin: EdgeInsets.fromLTRB(Dimensions.d_30,Dimensions.d_0,Dimensions.d_30,Dimensions.d_0),
        child: ListTile(
          title: Text(
            "Pilih Tarikh ...",
            style: TextStyle(
                color: Colours.darkGrey,
                fontSize: FontSizes.normal,
                fontWeight: FontWeight.w300),
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: Icon(Icons.keyboard_arrow_down),
          ),
        ),
      ),
    );
  });
}

Widget _timePickerField() {
  return StatefulBuilder(builder: (context, setState) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.d_10),
      child: Container(
        color: Colours.lightBlue,
        padding: EdgeInsets.all(Dimensions.d_0),
        margin: EdgeInsets.fromLTRB(Dimensions.d_30,Dimensions.d_0,Dimensions.d_30,Dimensions.d_0),
        child: ListTile(
          title: Text(
            "Pilih Masa ...",
            style: TextStyle(
                color: Colours.darkGrey,
                fontSize: FontSizes.normal,
                fontWeight: FontWeight.w300),
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: Icon(Icons.keyboard_arrow_down),
          ),
        ),
      ),
    );
  });
}
