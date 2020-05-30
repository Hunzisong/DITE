import 'package:flutter/material.dart';
import 'package:heard/constants.dart';
import 'package:heard/home/on_demand/on_demand_sli_page.dart';
import 'package:heard/home/on_demand/on_demand_user_page.dart';
import 'package:heard/home/reservation.dart';
import 'package:heard/home/profile.dart';
import 'package:heard/home/transaction.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  static bool isSLI = false;
  int _currentPageIndex = 0;
  // determine whether its user or sli tab pages
  final List<Widget> _pages = isSLI ? [OnDemandSLIPage(), Reservation(), Transaction(), Profile()] : [OnDemandUserPage(), Reservation(), Transaction(), Profile()];
  final List<String> _titles = ['Permintaan', 'Tempahan', 'Transaksi', 'Profil'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentPageIndex],
        style: TextStyle(
          fontSize: FontSizes.mainTitle,
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        backgroundColor: isSLI ? Colours.orange : Colours.blue,
      ),
      body: _pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (index) => onTabTapped(index),
          currentIndex: _currentPageIndex,
          backgroundColor: isSLI ? Colours.orange : Colours.blue,
          selectedItemColor: isSLI ? Colours.darkGrey : Colours.darkBlue,
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
