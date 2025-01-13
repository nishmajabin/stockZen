import 'package:flutter/material.dart';
import 'package:stockzen/constant.dart';

class CustomInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final BorderRadiusGeometry? borderRadius;

  const CustomInfoRow({
    Key? key,
    required this.label,
    required this.value,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    this.backgroundColor,
    this.labelStyle,
    this.valueStyle,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color.fromARGB(255, 185, 206, 221),
          borderRadius: borderRadius ??
              const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
          boxShadow: [
            BoxShadow(
              color: primaryColor
                  .withOpacity(0.5), // Shadow color with transparency
              spreadRadius: 1, // Spread radius
              blurRadius: 3, // Blur radius
              offset: const Offset(5, 5), // Shadow position (x, y)
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: labelStyle ??
                  TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 60, 58, 58),
                  ),
            ),
            Text(
              value,
              style: valueStyle ??
                  const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
