import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:calendar2/constants/gaps.dart';
import 'package:calendar2/constants/sizes.dart';
import 'package:calendar2/features/authentication/birthday_screen.dart';
import 'package:calendar2/features/widgets/form_button.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  // textField의 변화를 감지하기 위함
  final TextEditingController _passwordController = TextEditingController();

  String _password = "";
  bool _obscureText = true;

  @override
  void initState() {
    super.initState(); // 맨앞에 선언

    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose(); // 마지막에 선언 / 차이는 없는데 보기좋음
  }

  // 이메일 형식인지 확인
  bool _isPasswordValid() {
    // return _password.isNotEmpty && _password.length > 8;
    // 정규 표현식
    final regExp = RegExp(
        r"^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[@$!%*#?&\^])[A-Za-z0-9@$!%*#?&\^]{8,}$");
    if (!regExp.hasMatch(_password)) {
      return false;
    }
    return true;
  }

  // 화면 클릭해서 키보드 없애기
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void _onSubmit() {
    if (!_isPasswordValid()) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BirthdayScreen(),
      ),
    );
  }

  void _onClearTap() {
    _passwordController.clear();
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
                'Password',
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.v16,
              // TextField: 처음엔 enabled 상태, 탭하면 focused 상태로 바뀜
              TextField(
                controller: _passwordController,
                // 자동완성 끄기
                autocorrect: false,
                // 입력이 안보이게 함
                obscureText: _obscureText,
                // 완료버튼 누를때 입력창 값이 뭔지 모를때 유용함
                // onSubmitted: ,
                // 값을 알때
                onEditingComplete: _onSubmit,
                decoration: InputDecoration(
                  // 앞에있는 아이콘 prefix를 사용하여 Widget도 넣을 수 있음
                  // prefixIcon: const Icon(Icons.ac_unit),
                  // 뒤에있는 아이콘
                  // suffixIcon: const Icon(Icons.abc),
                  suffix: Row(
                    // Row가 모든 TextField의 자리를 차지하는것을 막기위해 최소 크기로 바꿈
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: _onClearTap,
                        child: FaIcon(
                          FontAwesomeIcons.solidCircleXmark,
                          color: Colors.grey.shade400,
                          size: Sizes.size20,
                        ),
                      ),
                      Gaps.h16,
                      GestureDetector(
                        onTap: _toggleObscureText,
                        child: FaIcon(
                          _obscureText
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash,
                          color: Colors.grey.shade400,
                          size: Sizes.size20,
                        ),
                      ),
                    ],
                  ),
                  hintText: "Make it strong!",
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
              Gaps.v10,
              const Text(
                'Your password must have:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gaps.v10,
              Column(
                children: [
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.circleCheck,
                        size: Sizes.size20,
                        color: _isPasswordValid()
                            ? Colors.green
                            : Colors.grey.shade400,
                      ),
                      Gaps.h5,
                      const Text('8 to 20 characters'),
                    ],
                  ),
                  Gaps.v10,
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.circleCheck,
                        size: Sizes.size20,
                        color: _isPasswordValid()
                            ? Colors.green
                            : Colors.grey.shade400,
                      ),
                      Gaps.h5,
                      const Text('Letters, numbers, and special characters'),
                    ],
                  ),
                ],
              ),

              Gaps.v16,
              GestureDetector(
                onTap: _onSubmit,
                child: FormButton(
                  disabled: !_isPasswordValid(),
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
