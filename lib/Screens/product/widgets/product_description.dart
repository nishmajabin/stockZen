import 'package:flutter/material.dart';
import 'package:stockzen/constant.dart';

class ProductDescriptionWidget extends StatelessWidget {
  final String description;
  final EdgeInsetsGeometry? padding;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const ProductDescriptionWidget({
    Key? key,
    required this.description,
    this.padding = const EdgeInsets.all(18),
    this.titleStyle,
    this.descriptionStyle,
    this.backgroundColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: titleStyle ??
                const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  backgroundColor ?? const Color.fromARGB(198, 168, 189, 203),
              borderRadius: borderRadius ??
                  const BorderRadius.all(
                    Radius.circular(12),
                  ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 27, 30, 33).withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 2.5,
                  offset: const Offset(0, 3), // Adjust for shadow direction
                ),
              ],
            ),
            child: Text(
              description,
              style: descriptionStyle ??
                  const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
