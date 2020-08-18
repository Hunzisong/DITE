import 'package:flutter/material.dart';
import 'package:heard/api/user.dart';
import 'package:heard/constants.dart';
import 'package:heard/firebase_services/auth_service.dart';
import 'package:heard/firebase_services/fcm.dart';
import 'package:heard/home/on_demand/on_demand_sli_page.dart';
import 'package:heard/home/on_demand/on_demand_user_page.dart';
import 'package:heard/home/reservation.dart';
import 'package:heard/home/profile.dart';
import 'package:heard/home/transaction.dart';
import 'package:heard/http_services/user_services.dart';

class Navigation extends StatefulWidget {
  final bool isSLI;

  Navigation({this.isSLI = false});

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentPageIndex = 0;
  List<Widget> _pages;
  final List<String> _titles = ['Permintaan', 'Tempahan', 'Transaksi', 'Profil'];
  bool showLoadingAnimation = false;
  String authToken;
  User userDetails;

  @override
  void initState() {
    super.initState();
    initializeUser();
  }

  void initializeUser() async {
    this.setState(() {
      showLoadingAnimation = true;
    });
    String token = await AuthService.getToken();
    User user = await UserServices().getUser(headerToken: token);
    setState(() {
      authToken = token;
      userDetails = user;
      showLoadingAnimation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Send FCM token depending on whether logged in is user or sli
    widget.isSLI ? print("User type: SLI") : print("User type: User");
    var fcm = FCM();
    widget.isSLI ? fcm.init("sli") : fcm.init("user");

    if (_pages == null && userDetails != null && authToken != null)
      // determine whether its user or sli tab pages
      _pages  = widget.isSLI ? [OnDemandSLIPage(), Reservation(), Transaction(), Profile(userDetails: userDetails)] : [OnDemandUserPage(), Reservation(), Transaction(), Profile(userDetails: userDetails)];

    return Scaffold(
      appBar: AppBar(
        leading: SizedBox.shrink(),
        title: Text(_titles[_currentPageIndex],
        style: TextStyle(
          fontSize: FontSizes.mainTitle,
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        backgroundColor: widget.isSLI ? Colours.orange : Colours.blue,
      ),
      body: showLoadingAnimation ? Center(child: CircularProgressIndicator()) : _pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (index) => onTabTapped(index),
          currentIndex: _currentPageIndex,
          backgroundColor: widget.isSLI ? Colours.orange : Colours.blue,
          selectedItemColor: widget.isSLI ? Colours.darkGrey : Colours.darkBlue,
          unselectedItemColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.search, size: Dimensions.d_30), title: Text('Permintaan')),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today, size: Dimensions.d_30), title: Text('Tempahan')),
            BottomNavigationBarItem(
                icon: Icon(Icons.history, size: Dimensions.d_30), title: Text('Transaksi')),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle, size: Dimensions.d_30), title: Text('Profil')),
          ]),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }
}
