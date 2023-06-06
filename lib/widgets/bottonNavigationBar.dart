import 'package:calendar2/screens/event_calendar_screen.dart';
// import 'package:calendar2/screens/search_screen.dart';
import 'package:calendar2/screens/profile_screen.dart';
import 'package:calendar2/screens/progresspage.dart';
import 'package:calendar2/screens/search_query.dart';
import 'package:calendar2/widgets/start.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../screens/friend_screens.dart';

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
    // const HomeScreen(),
    const EventCalendarScreen(),
    // const SearchScreen(),
    FriendScreen(),
    // const EventCalendar(),
    ProgressPage(),
    // const achievementScreen(),
    ProfileScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
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
                    backgroundColor: Color.fromARGB(255, 171, 216, 253),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: '검색',
                    backgroundColor: Color.fromARGB(255, 146, 206, 255),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart_rounded),
                    label: '달성도',
                    backgroundColor: Color.fromARGB(255, 149, 206, 253),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: '프로필',
                    backgroundColor: Color.fromARGB(255, 155, 210, 255),
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Color.fromARGB(255, 61, 88, 241),
                onTap: _onItemTapped,
              ),
            );
          } else {
            return const Start();
          }
        },
      ),
    );
  }
}
