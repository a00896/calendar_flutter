import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calendar2/constants/gaps.dart';
import 'package:calendar2/constants/sizes.dart';
import 'package:calendar2/features/onboarding/interests_screen.dart';
import 'package:calendar2/features/widgets/form_button.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  // textField의 변화를 감지하기 위함
  final TextEditingController _birthdayController = TextEditingController();

  DateTime initalDate = DateTime.now();

  @override
  void initState() {
    super.initState(); // 맨앞에 선언
    _setTextFieldDate(initalDate);
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose(); // 마지막에 선언 / 차이는 없는데 보기좋음
  }

  // StatefulWidget 이기 때문에 따로 context를 안받아와도 됨 , StatefulWidget 안에 있으면 context를 사용가능하기 떄문
  void _onNextTap() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const InterestesScreen()),
    );
  }

  void _setTextFieldDate(DateTime date) {
    final textDate = date.toString().split(" ").first;
    _birthdayController.value = TextEditingValue(text: textDate);
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
              "When's your birthday?",
              style: TextStyle(
                fontSize: Sizes.size20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.v8,
            const Text(
              "Your birthday won't be shown publicly",
              style: TextStyle(
                fontSize: Sizes.size16,
                color: Colors.black54,
              ),
            ),
            Gaps.v16,
            // TextField: 처음엔 enabled 상태, 탭하면 focused 상태로 바뀜
            TextField(
              controller: _birthdayController,
              enabled: false,
              decoration: InputDecoration(
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
              child: const FormButton(
                disabled: false,
                text: 'Next',
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 300,
          child: CupertinoDatePicker(
            maximumDate: initalDate,
            initialDateTime: initalDate,
            // 날짜만 있게 (시간은 지움)
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: _setTextFieldDate,
          ),
        ),
      ),
    );
  }
}

// Controller 코드, 메서드 등으로 위젯을 컨트롤 할 수 있게 해줌
