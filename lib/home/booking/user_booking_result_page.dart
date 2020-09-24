import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/firebase_services/auth_service.dart';
import 'package:heard/home/booking/user_booking_result_SLI_profile_page.dart';
import 'package:heard/http_services/booking_services.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heard/api/user.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UserBookingResultPage extends StatefulWidget {

  final String pickedDate;
  final String pickedTime;

  UserBookingResultPage({
    this.pickedDate,
    this.pickedTime});

  @override
  _UserBookingResultPageState createState() => _UserBookingResultPageState();
}

class _UserBookingResultPageState extends State<UserBookingResultPage> {
  List<DropdownMenuItem<String>> genderList;

  String selectedGender;

  List<DropdownMenuItem<String>> experienceList;

  String selectedExperience;

  List<Map<String, dynamic>> allSli;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getAllSli();
  }

  void loadGenderList() {
    genderList = [];
    genderList.add(new DropdownMenuItem(
      child: new Text('Lelaki'),
      value: 'male',
    ));

    genderList.add(new DropdownMenuItem(
      child: new Text('Perempuan'),
      value: "female",
    ));
  }

  void loadExperienceList() {
    experienceList = [];
    for (int i = 0; i < 10; i++) {
      experienceList.add(DropdownMenuItem(
        child: Text('$i Tahun'),
        value: i.toString(),
      ));
    }
  }

  Widget loadSliList() {
    return Column(
      children: allSli
          .map((sli) => SLITemplate(
              name: sli['name'].text, gender: sli['gender'], age: sli['age'], description: sli['description']))
          .toList(),
    );
  }

  Widget SLITemplate({String name, String gender, String age, String profilePic, String description}) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.d_25),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserBookingResultSLIProfilePage(
                name: name,
                gender: gender,
                age: age,
                profilePic: profilePic,
                description: description,
                pickedDate: widget.pickedDate,
                pickedTime: widget.pickedTime,
              )),
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
              width: Dimensions.d_100,
              height: Dimensions.d_100,
              child: Padding(
                padding: EdgeInsets.all(Dimensions.d_10),
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(Dimensions.d_20),
                  child: Image(
                    image: AssetImage(profilePic ?? 'images/avatar.png'),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Dimensions.d_20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichTextField("Nama", name),
                  RichTextField("Jantina", gender),
                  RichTextField("Umur", age),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getAllSli() async {
    String _authToken = await AuthService.getToken();
    List<User> _allSli = await BookingServices().getAllSLI(headerToken: _authToken);
    List<Map<String, dynamic>> _allSliJson = List<Map<String, dynamic>>();
    for (User sli in _allSli) {
      _allSliJson.add(sli.toJson());
    }
    setState(() {
      allSli = _allSliJson;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    loadGenderList();
    loadExperienceList();
    return loading
        ? Scaffold(
            backgroundColor: Colours.white,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SpinKitRing(
                  color: Colours.blue,
                  lineWidth: Dimensions.d_5,
                ),
                Padding(
                  padding: EdgeInsets.only(top: Dimensions.d_15),
                  child: Text(
                    'Sedang memuatkan, sila bersabar ...',
                    style: TextStyle(
                        fontSize: FontSizes.smallerText,
                        color: Colours.grey,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          )
        : SafeArea(
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
                    padding: EdgeInsets.fromLTRB(Dimensions.d_30,
                        Dimensions.d_10, Dimensions.d_30, Dimensions.d_30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: Dimensions.d_45,
                                child: DropdownList(
                                  hintText: "Jantina",
                                  selectedItem: selectedGender,
                                  itemList: genderList,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: Dimensions.d_10),
                            Expanded(
                              child: Container(
                                height: Dimensions.d_45,
                                child: DropdownList(
                                  hintText: "Pengalaman",
                                  selectedItem: selectedExperience,
                                  itemList: experienceList,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedExperience = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.d_20),
                        loadSliList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
