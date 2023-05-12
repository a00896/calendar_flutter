import 'package:calendar2/constants/colors.dart';
import 'package:calendar2/firebase_options.dart';
import 'package:calendar2/screens/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:calendar2/constants/sizes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        // 모든 scaffold BackgroundColor가 Colors.white로 바뀐다
        scaffoldBackgroundColor: Colors.white,
        primaryColor: primaryColor,

        // 모든 App Bar 글자색, 배경색 변경, titleTextStyle 변경
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color(0xFFeeeeee),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(
              0xFF232B55,
            ),
          ),
        ),
        bottomAppBarTheme: const BottomAppBarTheme(
          color: Color(0xFFCBECFF),
        ),
        cardColor: const Color(0xFFFFFFDD),
        cardTheme: const CardTheme(
          color: Color(0xFFFFF092),
        ),
      ),
      // home: const BottomNavigationBarWidgets(),
      home: const StartScreen(),
    );
  }
}
