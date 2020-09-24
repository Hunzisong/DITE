import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/home/booking/user_booking_success.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class UserBookingResultSLIProfilePage extends StatefulWidget {
  final String name;
  final String gender;
  final String age;
  final String description;
  final String profilePic;
  final String pickedDate;
  final String pickedTime;

  UserBookingResultSLIProfilePage({
    this.name,
    this.gender,
    this.age,
    this.description,
    this.profilePic,
    this.pickedTime,
    this.pickedDate,
  });

  @override
  _UserBookingResultSLIProfilePageState createState() =>
      _UserBookingResultSLIProfilePageState();
}

class _UserBookingResultSLIProfilePageState
    extends State<UserBookingResultSLIProfilePage> {
  TextEditingController notes = TextEditingController();

  void showUserInformation({int index}) {
    popUpDialog(
      context: context,
      isSLI: false,
      height: Dimensions.d_160 * 3.5,
      contentFlexValue: 5,
      buttonText: 'Mengesah',
      onClick: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserBookingSuccessPage()),
        );
      },
      header: 'Pengesahan',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.d_20),
              child: ListTile(
                isThreeLine: true,
                subtitle: ListView(
                  children: <Widget>[
                    RichTextField("Nama", widget.name),
                    RichTextField("Jantina", widget.gender),
                    RichTextField("Umur", widget.age),
                    RichTextField("Tarikh", widget.pickedDate),
                    RichTextField("Masa", widget.pickedTime),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(top: Dimensions.d_15),
              child: Container(
                height: Dimensions.d_100 * 2,
                decoration: BoxDecoration(
                  color: Colours.lightGrey,
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimensions.d_10)),
                  // border: Border.all(),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.d_25),
                  child: InputField(
                    controller: notes,
                    labelText: 'Nota kepada JBIM',
                    backgroundColour: Colours.lightGrey,
                    moreLines: true,
                    hintText: '(Tempoh masa meeting)',
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
      child: Scaffold(
        backgroundColor: Colours.white,
        appBar: AppBar(
          backgroundColor: Colours.blue,
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
        body: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(Dimensions.d_0, Dimensions.d_55,
                    Dimensions.d_0, Dimensions.d_10),
                child: Container(
                  height: Dimensions.d_100,
                  child: Image(
                    image: AssetImage(widget.profilePic ?? 'images/avatar.png'),
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                widget.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: FontSizes.title),
              ),
            ),
            SizedBox(height: Dimensions.d_20),
            Center(
              child: RichTextField("Jantina", widget.gender),
            ),
            Center(
              child: RichTextField("Umur", widget.age),
            ),
            Padding(
              padding: EdgeInsets.all(Dimensions.d_35),
              child: Container(
                height: Dimensions.d_160,
                decoration: BoxDecoration(
                  color: Colours.lightBlue,
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimensions.d_10)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.d_20),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Deskripsi",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: Dimensions.d_10),
                        Container(
                          child: Text(
                            widget.description,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: UserButton(
          text: 'Buat Tempahan',
          color: Colours.blue,
          padding: EdgeInsets.all(Dimensions.d_30),
          onClick: () {
            showUserInformation();
          },
        ),
      ),
    );
  }
}
