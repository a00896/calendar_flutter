import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:calendar2/constants/gaps.dart';
import 'package:calendar2/constants/sizes.dart';
import 'package:calendar2/features/authentication/login_screen.dart';
import 'package:calendar2/features/authentication/username_screen.dart';
import 'package:calendar2/features/widgets/auth_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  // StatelessWidget 이기 때문에 따로 context를 안받아와야 함
  void _onLoginTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 아이폰 위에 카메라 같은거에 가려지지않게 보호해주는 기능
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size40,
          ),
          child: Column(
            children: [
              Gaps.v80,
              const Text(
                'Sign up for Tiktok',
                style: TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v20,
              const Text(
                'Create a profile follow other accounts, make your own videos, and more.',
                style: TextStyle(
                  fontSize: Sizes.size16,
                  color: Colors.black45,
                ),
                textAlign: TextAlign.center,
              ),
              Gaps.v40,
              AuthButton(
                icon: const FaIcon(FontAwesomeIcons.user),
                text: "Use email & password",
                onTapFunc: (context) => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const UserNameScreen(),
                  ),
                ),
              ),
              Gaps.v16,
              AuthButton(
                icon: const FaIcon(FontAwesomeIcons.apple),
                text: "Continue with Apple",
                onTapFunc: (context) => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const UserNameScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey.shade50,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.size32,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account?'),
              Gaps.h5,
              GestureDetector(
                onTap: () => _onLoginTap(context),
                child: Text(
                  'Log in',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
