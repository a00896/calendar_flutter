import 'package:calendar2/features/authentication/login_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:calendar2/constants/gaps.dart';
import 'package:calendar2/constants/sizes.dart';
import 'package:calendar2/features/widgets/form_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpFormScreen extends StatefulWidget {
  const SignUpFormScreen({super.key});

  @override
  State<SignUpFormScreen> createState() => _SignUpFormScreenState();
}

class _SignUpFormScreenState extends State<SignUpFormScreen> {
  // 고유 식별자 역할, 폼의 state에 접근 가능, 폼의 메서드 실행 가능
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Map<String, String> formData = {};
  bool _isValid = true;
  bool _obscureText = true;
  bool _obscureConfirmText = true;

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
    _confirmPasswordController.addListener(() {
      setState(() {
        // _password = _passwordController.text;
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isValidEmailPassword() {
    _onSubmitTap();
    if (formData['email'].toString().isEmpty ||
        formData['password'].toString().isEmpty) {
      setState(() {
        _isValid = false;
      });
      return false;
    } else {
      print(formData);
      // 정규 표현식
      final regExpEmail = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
      final regExpPassword = RegExp(
          r"^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[@$!%*#?&\^])[A-Za-z0-9@$!%*#?&\^]{8,}$");

      if (regExpEmail.hasMatch(formData['email'].toString())) {
        if (regExpPassword.hasMatch(formData['password'].toString())) {
          setState(() {
            _isValid = true;
          });
          return true;
        }
      }

      setState(() {
        _isValid = false;
      });
      return false;
    }
  }

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        // 모든 field에 onSave(); 실행함
        _formKey.currentState!.save();
        // print(formData['email']);
        // print(formData.values);
      }
    }
  }

  void _onLoginTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginFormScreen(),
      ),
    );
  }

  void _onClearTap() {
    _passwordController.clear();
  }

  void _onConfirmClearTap() {
    _confirmPasswordController.clear();
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleObscureConfirmText() {
    setState(() {
      _obscureConfirmText = !_obscureConfirmText;
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
          title: const Text('Sign up'),
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
                    Gaps.v16,
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmText,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        suffix: Row(
                          // Row가 모든 TextField의 자리를 차지하는것을 막기위해 최소 크기로 바꿈
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: _onConfirmClearTap,
                              child: FaIcon(
                                FontAwesomeIcons.solidCircleXmark,
                                color: Colors.grey.shade400,
                                size: Sizes.size20,
                              ),
                            ),
                            Gaps.h16,
                            GestureDetector(
                              onTap: _toggleObscureConfirmText,
                              child: FaIcon(
                                _obscureConfirmText
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
                          formData['confirmPassword'] = newValue;
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
            onTap: () => _onLoginTap(context),
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '로그인',
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
