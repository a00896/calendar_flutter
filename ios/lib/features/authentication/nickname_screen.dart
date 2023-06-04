import 'package:calendar2/widgets/bottonNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:calendar2/constants/gaps.dart';
import 'package:calendar2/constants/sizes.dart';
import 'package:calendar2/features/widgets/form_button.dart';

class NicknameScreen extends StatefulWidget {
  const NicknameScreen({super.key});

  @override
  State<NicknameScreen> createState() => _NicknameScreenState();
}

class _NicknameScreenState extends State<NicknameScreen> {
  // textField의 변화를 감지하기 위함
  final TextEditingController _nicknameController = TextEditingController();

  String _nickname = "";

  @override
  void initState() {
    super.initState(); // 맨앞에 선언

    _nicknameController.addListener(() {
      setState(() {
        _nickname = _nicknameController.text;
      });
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose(); // 마지막에 선언 / 차이는 없는데 보기좋음
  }

  // 이메일 형식인지 확인
  bool _isNicknameValid() {
    if (_nickname.isEmpty) return true;
    // 정규 표현식
    return false;
  }

  // 화면 클릭해서 키보드 없애기
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void _onSubmit() {
    if (_isNicknameValid()) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BottomNavigationBarWidgets(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "nickname",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v20,
              const Text(
                'What is your Nickname',
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.v16,
              // TextField: 처음엔 enabled 상태, 탭하면 focused 상태로 바뀜
              TextField(
                controller: _nicknameController,
                // 자동완성 끄기
                autocorrect: false,

                // 완료버튼 누를때 입력창 값이 뭔지 모를때 유용함
                // onSubmitted: ,
                // 값을 알때
                onEditingComplete: _onSubmit,
                // 키보드 타입
                decoration: InputDecoration(
                  hintText: "Nickname",
                  errorText: "이름을 입력해주세요.",
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
                onTap: _onSubmit,
                child: FormButton(
                  disabled: !_isNicknameValid(),
                  text: 'Next',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Controller 코드, 메서드 등으로 위젯을 컨트롤 할 수 있게 해줌
