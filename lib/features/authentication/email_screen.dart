import 'package:flutter/material.dart';
import 'package:calendar2/constants/gaps.dart';
import 'package:calendar2/constants/sizes.dart';
import 'package:calendar2/features/authentication/password_screen.dart';
import 'package:calendar2/features/widgets/form_button.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  // textField의 변화를 감지하기 위함
  final TextEditingController _emailController = TextEditingController();

  String _email = "";

  @override
  void initState() {
    super.initState(); // 맨앞에 선언

    _emailController.addListener(() {
      setState(() {
        _email = _emailController.text;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose(); // 마지막에 선언 / 차이는 없는데 보기좋음
  }

  // 이메일 형식인지 확인
  String? _isEmailValid() {
    if (_email.isEmpty) return null;
    // 정규 표현식
    final regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!regExp.hasMatch(_email)) {
      return "Email not valid";
    }
    return null;
  }

  // 화면 클릭해서 키보드 없애기
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void _onSubmit() {
    if (_email.isEmpty || _isEmailValid() != null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PasswordScreen(),
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
                'What is your email',
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.v16,
              // TextField: 처음엔 enabled 상태, 탭하면 focused 상태로 바뀜
              TextField(
                controller: _emailController,
                // 자동완성 끄기
                autocorrect: false,

                // 완료버튼 누를때 입력창 값이 뭔지 모를때 유용함
                // onSubmitted: ,
                // 값을 알때
                onEditingComplete: _onSubmit,
                // 키보드 타입
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                  errorText: _isEmailValid(),
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
                  disabled: _email.isEmpty || _isEmailValid() != null,
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
