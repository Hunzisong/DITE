import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/firebase_services/auth_service.dart';
import 'package:heard/home/booking/user_booking_result_SLI_profile_page.dart';
import 'package:heard/http_services/booking_services.dart';
import 'package:heard/widgets/loading_screen.dart';
import 'package:heard/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heard/api/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserBookingResultPage extends StatefulWidget {
  final String pickedDate;
  final String pickedTime;
  final String hospitalName;
  final String preferredLanguage;

  UserBookingResultPage(
      {this.hospitalName,
        this.pickedDate,
        this.pickedTime,
        this.preferredLanguage});

  @override
  _UserBookingResultPageState createState() => _UserBookingResultPageState();
}

class _UserBookingResultPageState extends State<UserBookingResultPage> {
  List<DropdownMenuItem<String>> genderList;

  String selectedGender;

  List<DropdownMenuItem<String>> experienceList;

  String selectedExperience;

  List<Map<String, dynamic>> allSli;
  List <Map<String, dynamic>> filterSLIGenderList ;
  List <Map<String, dynamic>> filterSliExperienceList ;
  List <Map<String, dynamic>> filterSliList ;


  bool loading = true;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

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

    genderList.add(new DropdownMenuItem(
      child: new Text('Semua'),
      value: "all",
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

    experienceList.add(new DropdownMenuItem(
      child: new Text('Semua'),
      value: "all",
    ));
  }

  Widget loadSliList() {
    return Column(
      children:allSli.map((sli) => createSLITemplate(
          id: sli['sli_id'],
          name: sli['name'],
          gender: sli['gender'],
          age: sli['age'],
          description: sli['description']))
          .toList(),
    );
  }

  Widget loadFilteredSliList() {
    getFilterList();
    return ListView.builder(
      scrollDirection: Axis.vertical,
      controller: ScrollController(),
      shrinkWrap: true,
      itemCount: filterSliList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            createSLITemplate(
              id: filterSliList[index]['sli_id'],
              name: filterSliList[index]['name'],
              gender: filterSliList[index]['gender'],
              age: filterSliList[index]['age'],
              description: filterSliList[index]['description'],
            ),
            SizedBox(height: Dimensions.d_10)
          ],
        );
      },
    );
  }

  Widget createSLITemplate(
      {String id,
        String name,
        String gender,
        String age,
        String profilePic,
        String description}) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.d_25),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserBookingResultSLIProfilePage(
                id: id,
                name: name,
                gender: gender,
                age: age,
                profilePic: profilePic,
                description: description,
                pickedDate: widget.pickedDate,
                pickedTime: widget.pickedTime,
                hospitalName: widget.hospitalName,
                preferredLanguage: widget.preferredLanguage,
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
                  //RichTextField("Umur", age),
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
    List<User> _allSli =
    await BookingServices().getAllSLI(headerToken: _authToken);
    List<Map<String, dynamic>> _allSliJson = List<Map<String, dynamic>>();
    for (User sli in _allSli) {
      _allSliJson.add(sli.toJson());
    }
    setState(() {
      allSli = _allSliJson;
      loading = false;
    });
  }

  void _onRefresh() async {
    await getAllSli();
    if (allSli == null) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.refreshCompleted();
      setState(() {
        selectedGender = null;
        selectedExperience = null;
      });
    }
  }

  void getFilterList() {
    filterSLIGenderList=[];
    filterSliExperienceList=[];
    filterSliList=[];

    if (selectedGender != null && selectedGender != 'all') {
      allSli.forEach((element) {
        if (element['gender'] == selectedGender){
           filterSLIGenderList.add(element);
         }
       });
    }
    else {
      allSli.forEach((element) {
        filterSLIGenderList.add(element);});
    }

    if (selectedExperience != null && selectedExperience != 'all') {
      allSli.forEach((element) {
        if (element['years_medical'].toString() == selectedExperience){
          filterSliExperienceList.add(element);
        }
      });
    }
    else {
      allSli.forEach((element) {
        filterSliExperienceList.add(element);});
    }

    for (var sli in filterSLIGenderList) {
      if (filterSliExperienceList.contains(sli)) {
        filterSliList.add(sli);
      }
    }
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
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context, false);
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
          body: loading
              ? LoadingScreen()
              : SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            enablePullDown: true,
            header: ClassicHeader(),
            child: ListView(
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
                            flex: 8,
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
                            flex: 10,
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
                      loadFilteredSliList() ,
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
