import 'package:calendar2/widgets/start.dart';
import 'package:calendar2/widgets/bottonNavigationBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return const BottomNavigationBarWidgets();
          } else {
            return const Start();
          }
        }));
  }
}
