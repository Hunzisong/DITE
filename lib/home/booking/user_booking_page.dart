import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:intl/intl.dart';

class UserBookingPage extends StatefulWidget {
  @override
  _UserBookingPageState createState() => _UserBookingPageState();
}

class _UserBookingPageState extends State<UserBookingPage> {

  TimeOfDay startTime;
  DateTime startDate;
  String formattedDate;

  List <DropdownMenuItem <String>> languageList = [];
  String selectedLanguage;

  List <DropdownMenuItem <String>> clinicList = [];
  String selectedClinic;

  String _getFormattedTime(TimeOfDay currentTime) {
    return currentTime.toString().substring(
        currentTime.toString().length - 6, currentTime.toString().length - 1);
  }

  Future<TimeOfDay> _pickTime({bool isStart = true}) async {
    TimeOfDay selectedTime =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    return selectedTime;
  }

  Future<DateTime> _pickDate({bool isStart = true}) async {
    DateTime selectedDate =
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2021)
    );
    return selectedDate;
  }

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

  Widget _timePickerField(String initialTitle, TimeOfDay currentTime) {
    return StatefulBuilder(builder: (context, setState) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.d_10),
        child: Container(
          color: Colours.lightBlue,
          padding: EdgeInsets.all(Dimensions.d_0),
//          margin: EdgeInsets.fromLTRB(Dimensions.d_30,Dimensions.d_0,Dimensions.d_30,Dimensions.d_0),
          child: ListTile(
            title: Text(
              currentTime == null
                  ? initialTitle
                  : _getFormattedTime(currentTime),
              style: TextStyle(
                  color: Colours.darkGrey,
                  fontSize: FontSizes.normal,
                  fontWeight: FontWeight.w300),
            ),
            trailing: IconButton(
              icon: Icon(Icons.keyboard_arrow_down),
              onPressed: () async {
                TimeOfDay selectedTime = await _pickTime();
                if (selectedTime != null) {
                  setState(() {
                    currentTime = selectedTime;
                  });
                }
              },
            ),
          ),
        ),
      );
    });
  }

  Widget _datePickerField(String initialTitle, DateTime currentDate) {
    return StatefulBuilder(builder: (context, setState) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.d_10),
        child: Container(
          color: Colours.lightBlue,
          padding: EdgeInsets.all(Dimensions.d_0),
//          margin: EdgeInsets.fromLTRB(Dimensions.d_30,Dimensions.d_0,Dimensions.d_30,Dimensions.d_0),
          child: ListTile(
            title: Text(
              currentDate == null
                  ? initialTitle
                  : DateFormat('yyyy-MM-dd').format(currentDate),
              style: TextStyle(
                  color: Colours.darkGrey,
                  fontSize: FontSizes.normal,
                  fontWeight: FontWeight.w300),
            ),
            trailing: IconButton(
              icon: Icon(Icons.keyboard_arrow_down),
              onPressed: () async {
                DateTime selectedDate= await _pickDate();
                if (selectedDate != null) {
                  setState(() {
                    currentDate = selectedDate;
                  });
                }
              },
            ),
          ),
        ),
      );
    });
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
            Padding(
              padding: EdgeInsets.all(Dimensions.d_30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: SizedBox(
                      height: Dimensions.d_160,
                      child: Image(
                          image: AssetImage('images/booking_calendar.png')
                      ),
                    ),
                  ),
                  Ink(
                    decoration: BoxDecoration(
                        color: Colours.lightOrange,
                        borderRadius:
                        BorderRadius.all(Radius.circular(Dimensions.d_10))
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimensions.d_10)),
                      title: Text(startDate == null ? 'Pilih Tarikh ...' : DateFormat('yyyy-MM-dd').format(startDate)),
                      trailing: Icon(Icons.keyboard_arrow_down),
                      onTap: () async {
                        DateTime selectedDate= await _pickDate();
                        if (selectedDate != null) {
                          setState(() {
                            startDate = selectedDate;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.d_15,
                  ),
                  FieldLabel(
                    text:"Tarikh Temu Janji",
                  ),
                  SizedBox(
                    height: Dimensions.d_5,
                  ),
                  _datePickerField(
                      "Pilih Tarikh..",
                      startDate),
                  SizedBox(
                    height: Dimensions.d_5,
                  ),
                  FieldLabel(
                    text:"Masa Temu Janji",
                  ),
                  SizedBox(
                    height: Dimensions.d_5,
                  ),
                  _timePickerField(
                      "Pilih Masa..",
                      startTime),
                  FieldLabel(
                    text:"Pilihan Bahasa",
                  ),
                  SizedBox(
                    height: Dimensions.d_5,
                  ),
                  DropdownList(
                    hintText: "Bahasa Malaysia",
                    selectedItem: selectedLanguage,
                    itemList: languageList,
                    onChanged: (value){
                      setState(() {
                        selectedLanguage= value;
                      });
                    },
                  ),
                  SizedBox(
                    height: Dimensions.d_5,
                  ),
                  FieldLabel(
                    text:"Nama Hospital / Klinik",
                  ),
                  SizedBox(
                    height: Dimensions.d_5,
                  ),
                  DropdownList(
                    hintText: "Klinik A",
                    selectedItem: selectedClinic,
                    itemList: clinicList,
                    onChanged: (value){
                      setState(() {
                        selectedClinic= value;
                      });
                    },
                  ),
                  SizedBox(
                    height: Dimensions.d_45,
                  ),
                  UserButton(
                    text: 'Carian',
//                    padding: EdgeInsets.all(Dimensions.d_30),
                    color: Colours.blue,
                    onClick: (){},
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}