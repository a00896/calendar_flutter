import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:calendar2/constants/sizes.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final FaIcon icon;
  final void Function(BuildContext) onTapFunc;

  const AuthButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTapFunc,
  });

  @override
  Widget build(BuildContext context) {
    // FractionallySizedBox : 부모의 크기에 비례해서 크기를 조정해주는 위젯
    return GestureDetector(
      onTap: () => onTapFunc(context),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizes.size14),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size14,
              horizontal: Sizes.size14,
            ),
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.grey.shade200,
              width: Sizes.size1,
            )),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: icon,
                ),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: Sizes.size16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
