import 'package:flutter/material.dart';
import 'package:calendar2/constants/gaps.dart';
import 'package:calendar2/constants/sizes.dart';
import 'package:calendar2/features/authentication/email_screen.dart';
import 'package:calendar2/features/widgets/form_button.dart';

class UserNameScreen extends StatefulWidget {
  const UserNameScreen({super.key});

  @override
  State<UserNameScreen> createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserNameScreen> {
  // textField의 변화를 감지하기 위함
  final TextEditingController _usernameController = TextEditingController();

  String _username = "";

  @override
  void initState() {
    super.initState(); // 맨앞에 선언

    _usernameController.addListener(() {
      setState(() {
        _username = _usernameController.text;
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose(); // 마지막에 선언 / 차이는 없는데 보기좋음
  }

  // StatefulWidget 이기 때문에 따로 context를 안받아와도 됨 , StatefulWidget 안에 있으면 context를 사용가능하기 떄문
  void _onNextTap() {
    if (_username.isEmpty) {
      return;
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const EmailScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Sign up",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v20,
            const Text(
              'Create UserName',
              style: TextStyle(
                fontSize: Sizes.size20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.v8,
            const Text(
              'You can always change this later',
              style: TextStyle(
                fontSize: Sizes.size16,
                color: Colors.black54,
              ),
            ),
            Gaps.v16,
            // TextField: 처음엔 enabled 상태, 탭하면 focused 상태로 바뀜
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: "Username",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              cursorColor: Theme.of(context).primaryColor,
            ),
            Gaps.v16,
            GestureDetector(
              onTap: _onNextTap,
              child: FormButton(
                disabled: _username.isEmpty,
                text: 'Next',
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Controller 코드, 메서드 등으로 위젯을 컨트롤 할 수 있게 해줌
