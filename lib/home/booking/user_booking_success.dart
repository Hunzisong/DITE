import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heard/widgets/user_button.dart';

class UserBookingSuccessPage extends StatefulWidget {
  @override
  _UserBookingSuccessPageState createState() => _UserBookingSuccessPageState();
}

class _UserBookingSuccessPageState extends State<UserBookingSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colours.white,
      appBar: AppBar(
        backgroundColor: Colours.blue,
        leading: SizedBox.shrink(),
        title: Text(
          'Status Tempahan',
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
            SizedBox(
              height: Dimensions.d_35,
            ),
            Center(
              child: SizedBox(
                height: Dimensions.d_200,
                child: FittedBox(
                  child: Image(
                    image: AssetImage('images/bookingSuccessTick.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.d_35,
            ),
            Center(
              child: Text(
                "Tempahan Dibuat",
                style: TextStyle(fontSize: FontSizes.mainTitle,
                    color: Colours.accept,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: Dimensions.d_200,
            ),
            Padding(
              padding: EdgeInsets.all(Dimensions.d_10),
              child: UserButton(
                text: 'Balik Ke Laman Utama',
                color: Colours.blue,
                onClick: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
      ),
    );
  }
}
