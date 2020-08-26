import 'package:flutter/material.dart';
import 'package:heard/api/sli.dart';
import 'package:heard/api/user.dart';
import 'package:heard/constants.dart';
import 'package:heard/firebase_services/auth_service.dart';
import 'package:heard/firebase_services/fcm.dart';
import 'package:heard/home/on_demand/on_demand_sli_page.dart';
import 'package:heard/home/on_demand/on_demand_user_page.dart';
import 'package:heard/home/reservation.dart';
import 'package:heard/home/profile.dart';
import 'package:heard/home/transaction.dart';
import 'package:heard/http_services/sli_services.dart';
import 'package:heard/http_services/user_services.dart';
import 'package:google_fonts/google_fonts.dart';

class Navigation extends StatefulWidget {
  final bool isSLI;

  Navigation({this.isSLI = false});

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentPageIndex = 0;
  List<Widget> _pages;
  final List<String> _titles = [
    'Permintaan',
    'Tempahan',
    'Transaksi',
    'Profil'
  ];
  bool showLoadingAnimation = false;
  String authToken;
  dynamic userDetails;
  final pageController = PageController();

  @override
  void initState() {
    super.initState();
    initializeUser();
  }

  void initializeUser() async {
    setState(() {
      showLoadingAnimation = true;
    });
    String token = await AuthService.getToken();
    print('Auth Token: $token');
    User user;
    SLI sli;
    if (widget.isSLI == false) {
      user = await UserServices().getUser(headerToken: token);
    } else {
      sli = await SLIServices().getSLI(headerToken: token);
    }
    setState(() {
      authToken = token;
      userDetails = widget.isSLI ? sli : user;
      showLoadingAnimation = false;
    });
  }

  void onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Send FCM token depending on whether logged in is user or sli
    widget.isSLI ? print("User type: SLI") : print("User type: User");

    if (_pages == null && userDetails != null && authToken != null) {
      // determine whether its user or sli tab pages
      _pages = widget.isSLI
          ? [
              OnDemandSLIPage(),
              Reservation(),
              Transaction(),
              Profile(userDetails: userDetails)
            ]
          : [
              OnDemandUserPage(),
              Reservation(),
              Transaction(),
              Profile(userDetails: userDetails)
            ];
      var fcm = FCM();
      widget.isSLI ? fcm.init("sli") : fcm.init("user");
    }

    return Scaffold(
      appBar: AppBar(
        leading: SizedBox.shrink(),
        title: Text(
          _titles[_currentPageIndex],
          style: GoogleFonts.lato(
            fontSize: FontSizes.mainTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: widget.isSLI ? Colours.orange : Colours.blue,
      ),
      body: showLoadingAnimation
          ? Center(child: CircularProgressIndicator())
          : PageView(
              children: _pages,
              controller: pageController,
              onPageChanged: onPageChanged,
            ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            pageController.jumpToPage(index);
          },
          currentIndex: _currentPageIndex,
          backgroundColor: widget.isSLI ? Colours.orange : Colours.blue,
          selectedItemColor: widget.isSLI ? Colours.darkGrey : Colours.darkBlue,
          unselectedItemColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.search, size: Dimensions.d_30),
                title: Text('Permintaan')),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today, size: Dimensions.d_30),
                title: Text('Tempahan')),
            BottomNavigationBarItem(
                icon: Icon(Icons.history, size: Dimensions.d_30),
                title: Text('Transaksi')),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle, size: Dimensions.d_30),
                title: Text('Profil')),
          ]),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }
}
