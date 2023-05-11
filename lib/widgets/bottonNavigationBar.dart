import 'package:calendar2/screens/achievement_screen.dart';
// import 'package:calendar2/screen/event_calendar_screen.dart';
import 'package:calendar2/screens/home_screen.dart';
import 'package:calendar2/screens/profile_screen.dart';
import 'package:calendar2/screens/search_screen.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarWidgets extends StatefulWidget {
  const BottomNavigationBarWidgets({super.key});

  @override
  State<BottomNavigationBarWidgets> createState() =>
      _BottomNavigationBarWidgetsState();
}

class _BottomNavigationBarWidgetsState
    extends State<BottomNavigationBarWidgets> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    // const EventCalendarScreen(),
    const SearchScreen(),
    const achievementScreen(),
    const ProfileScreen()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //   appBar: AppBar(
        //     title: const Text('BottomNavigationBar Sample'),
        //   ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '검색',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: '달성도',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '프로필',
              backgroundColor: Colors.blue,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
