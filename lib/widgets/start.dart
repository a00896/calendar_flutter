import 'package:calendar2/constants/gaps.dart';
import 'package:calendar2/features/authentication/login_form_screen.dart';
import 'package:flutter/material.dart';

//1111
class Start extends StatelessWidget {
  const Start({super.key});

  void _onLoginTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginFormScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Gaps.v96,
            Text(
              'every\ncalendar',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 64,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Image.asset('assets/images/main_todo.png'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: GestureDetector(
          onTap: () => _onLoginTap(context),
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Log in',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gaps.h10,
                Icon(
                  Icons.arrow_forward_outlined,
                  size: 30,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
