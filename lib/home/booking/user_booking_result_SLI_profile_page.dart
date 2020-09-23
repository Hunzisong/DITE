import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class UserBookingResultSLIProfilePage extends StatefulWidget {
  @override
  _UserBookingResultSLIProfilePageState createState() => _UserBookingResultSLIProfilePageState();
}

class _UserBookingResultSLIProfilePageState extends State<UserBookingResultSLIProfilePage> {

  void showUserInformation({int index}) {
    popUpDialog(
      context: context,
      isSLI: false,
      height: Dimensions.d_130 * 3.5,
      contentFlexValue: 3,
      buttonText: 'Mengesah',
      onClick: () {
        Navigator.pop(context);
      },
      header: 'Pengesahan',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: ListTile(
              isThreeLine: true,
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'a',
                    style: TextStyle(color: Colours.darkGrey),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(top: Dimensions.d_35),
              child: Container(
                height: Dimensions.d_280,
                decoration: BoxDecoration(
                  color: Colours.white,
                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.d_10)),
                  border: Border.all(),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.d_25),
                  child: InputField(
                    //       controller: onDemandInputs.noteToSLI,
                    labelText: 'Nota kepada JBIM \n(Tempoh masa meeting)',
                    backgroundColour: Colours.white,
                    moreLines: true,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
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
            'Profil JBIM',
            style: GoogleFonts.lato(
              fontSize: FontSizes.mainTitle,
              fontWeight: FontWeight.bold,
              color: Colours.white,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body:ListView(
          children: <Widget> [
            Center(
              child:Padding(
                padding: EdgeInsets.fromLTRB(Dimensions.d_0, Dimensions.d_55, Dimensions.d_0, Dimensions.d_10),
                child: Container(
                  height: Dimensions.d_100,
                  child: Image(
                    image: AssetImage('images/avatar.png'),
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                "Hun",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: FontSizes.title),
              ),
            ),
            SizedBox(height: Dimensions.d_20),
            Center(
              child: RichText(
                text:TextSpan(
                  style: new TextStyle(
                    fontSize: FontSizes.normal,
                    color: Colours.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Jantina: ',
                        style: new TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: 'Lelaki',
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: RichText(
                text:TextSpan(
                  style: new TextStyle(
                    fontSize: FontSizes.normal,
                    color: Colours.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Umur: ',
                        style: new TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: '60',
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Dimensions.d_20),
              child: Container(
                height:Dimensions.d_160,
                decoration:BoxDecoration(
                  color:Colours.lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.d_10)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.d_10),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            "Deskripsi",
                            style: new TextStyle(fontWeight: FontWeight.bold)
                        ),
                        SizedBox(height: Dimensions.d_10),
                        Container(
                          child:Text(
                            "75 year old man looking to feed a family with sign language interpretation. 60 years of experience in the field.",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height:Dimensions.d_65),
            Padding(
              padding: EdgeInsets.all(Dimensions.d_10),
              child: UserButton(
                text: 'Buat Tempahan',
                color: Colours.blue,
                onClick: (){
                  showUserInformation();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
