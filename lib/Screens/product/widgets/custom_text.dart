import 'package:flutter/material.dart';
import 'package:stockzen/constant.dart';

class CustomText extends StatelessWidget {
  final String text;

  const CustomText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 35),
        child: Text(
          text,
          style: const TextStyle(
            color: primaryColor, 
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
