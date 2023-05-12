import 'package:flutter/material.dart';
import 'package:calendar2/constants/gaps.dart';
import 'package:calendar2/constants/sizes.dart';
import 'package:calendar2/features/widgets/form_button.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  // 고유 식별자 역할, 폼의 state에 접근 가능, 폼의 메서드 실행 가능
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        // 모든 field에 onSave(); 실행함
        _formKey.currentState!.save();
        print(formData);
        print(formData.values);
      }
    }
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
            // title: const Text('Log in'),
            ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size36,
            ),
            child: Form(
                key: _formKey,
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
                      decoration: const InputDecoration(
                        hintText: 'Password',
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
                      child: const FormButton(
                        disabled: false,
                        text: 'Log in',
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
