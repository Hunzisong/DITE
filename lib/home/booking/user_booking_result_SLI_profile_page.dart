import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/home/booking/user_booking_result_page.dart';
import 'package:heard/widgets/widgets.dart';

class UserBookingResultSLIProfilePage extends StatefulWidget {
  @override
  _UserBookingResultSLIProfilePageState createState() => _UserBookingResultSLIProfilePageState();
}

class _UserBookingResultSLIProfilePageState extends State<UserBookingResultSLIProfilePage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
        backgroundColor: Colours.white,
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
            SizedBox(height:Dimensions.d_100),
            Padding(
              padding: EdgeInsets.all(Dimensions.d_10),
              child: UserButton(
                text: 'Buat Tempahan',
                color: Colours.blue,
                onClick: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserBookingResultPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
