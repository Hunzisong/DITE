import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/home/booking/user_booking_result_SLI_profile_page.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';


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

  Widget SLITemplate(){
    return InkWell(
      borderRadius:BorderRadius.circular(Dimensions.d_25),
      onTap:(){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserBookingResultSLIProfilePage()),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.d_20),
        ),
        elevation: Dimensions.d_10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width:Dimensions.d_100,
              height: Dimensions.d_100,
              child: Padding(
                padding: EdgeInsets.all(Dimensions.d_10),
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(Dimensions.d_20),
                  child:Image(
                    image: AssetImage('images/avatar.png'),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Dimensions.d_20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget> [
                  RichTextField("Nama","Hun"),
                  RichTextField("Jantina","Lelaki"),
                  RichTextField("Umur","60"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    loadGenderList();
    loadExperienceList();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colours.white,
        appBar: AppBar(
          backgroundColor: Colours.blue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Hasil Carian',
            style: GoogleFonts.lato(
              fontSize: FontSizes.mainTitle,
              fontWeight: FontWeight.bold,
              color: Colours.white,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(Dimensions.d_30,Dimensions.d_10,Dimensions.d_30,Dimensions.d_30),
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
                  SLITemplate(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
