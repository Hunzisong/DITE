import 'package:flutter/material.dart';
import 'package:heard/home/home.dart';
import 'package:heard/home/schedule.dart';
import 'package:heard/home/settings.dart';
import 'package:heard/home/transaction.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentPageIndex = 0;
  final List<Widget> _pages = [Home(), Schedule(), Transaction(), Settings()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heard Deaf Project'),
      ),
      body: _pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (index) => onTabTapped(index),
          currentIndex: _currentPageIndex,
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.blue[900],
          unselectedItemColor: Colors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.schedule), title: Text('Schedule')),
            BottomNavigationBarItem(
                icon: Icon(Icons.attach_money), title: Text('Transaction')),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), title: Text('Settings')),
          ]),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }
}
