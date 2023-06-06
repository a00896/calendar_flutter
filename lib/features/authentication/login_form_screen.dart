import 'package:calendar2/features/authentication/sign_up_form_screen.dart';
import 'package:calendar2/screens/home_screen.dart';
import 'package:calendar2/widgets/bottonNavigationBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:calendar2/constants/gaps.dart';
import 'package:calendar2/constants/sizes.dart';
import 'package:calendar2/features/widgets/form_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  // 고유 식별자 역할, 폼의 state에 접근 가능, 폼의 메서드 실행 가능
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  Map<String, String> formData = {};
  // String _password = "";
  bool _isValid = true;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isValid = _isValidEmailPassword();
    });

    _passwordController.addListener(() {
      setState(() {
        // _password = _passwordController.text;
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmailPassword() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        // 모든 field에 onSave(); 실행함
        _formKey.currentState!.save();
      }
    }
    if (formData['email'].toString().isEmpty ||
        formData['password'].toString().isEmpty) {
      setState(() {
        _isValid = false;
      });
      return false;
    } else {
      // print(formData);
      // // 정규 표현식
      // final regExpEmail = RegExp(
      //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
      // final regExpPassword = RegExp(
      //     r"^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[@$!%*#?&\^])[A-Za-z0-9@$!%*#?&\^]{8,}$");

      // if (regExpEmail.hasMatch(formData['email'].toString())) {
      //   if (regExpPassword.hasMatch(formData['password'].toString())) {
      //     setState(() {
      //       _isValid = true;
      //     });
      //     return true;
      //   }
      // }

      // setState(() {
      //   _isValid = false;
      // });
      // return false;
    }
    setState(() {
      _isValid = true;
    });
    return true;
  }

  void _onSubmitTap() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        // 모든 field에 onSave(); 실행함
        _formKey.currentState!.save();
      }
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: formData['email'].toString(),
        password: formData['password'].toString(),
      );
      print('login');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const BottomNavigationBarWidgets(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void _onSignUpTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpFormScreen(),
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

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Log in'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size36,
            ),
            child: Form(
                key: _formKey,
                onChanged: _isValidEmailPassword,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'every\ncalendar',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 64,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gaps.v40,
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      // 유효성 검사 return에 값이 들어가면 TextField에 Error 실행
                      validator: (value) {
                        return null;
                      },
                      onSaved: (newValue) {
                        if (newValue != null) {
                          formData['email'] = newValue;
                        }
                      },
                    ),
                    Gaps.v16,
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: 'Password',
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
                      ),
                      validator: (value) {
                        return null;
                      },
                      onSaved: (newValue) {
                        if (newValue != null) {
                          formData['password'] = newValue;
                        }
                      },
                    ),
                    Gaps.v28,
                    GestureDetector(
                      onTap: _onSubmitTap,
                      child: FormButton(
                        disabled: !_isValid,
                        text: '로그인',
                      ),
                    )
                  ],
                )),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: GestureDetector(
            onTap: () => _onSignUpTap(context),
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '회원가입',
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
      ),
    );
  }
}
