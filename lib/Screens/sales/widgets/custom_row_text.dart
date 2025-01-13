import 'package:flutter/material.dart';
import 'package:stockzen/constant.dart';

class CustomRowWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  

  const CustomRowWidget({
    Key? key,
    required this.icon,
    required this.text,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: primaryColor),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
