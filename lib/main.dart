import 'package:calendar2/widgets/bottonNavigationBar.dart';
import 'package:flutter/material.dart';

void main() {
  // initializeDataFormatting().then((_) => runApp(MainApp()));
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color(0xFFeeeeee),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              color: Color(
            0xFF232B55,
          )),
        ),
        cardColor: const Color(0xFFFFFFDD),
        cardTheme: const CardTheme(
          color: Color(0xFFFFF092),
        ),
      ),
      home: const BottomNavigationBarWidgets(),
    );
  }
}
