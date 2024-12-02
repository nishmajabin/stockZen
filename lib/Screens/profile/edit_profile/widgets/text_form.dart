import 'package:flutter/material.dart';
import 'package:stockzen/constant.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final double? width;
  final double? height;
  final String? suffixText;
  final IconData? icon;
  final String? hintText;
  final double? borderRadius;
  final String? labelText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String?>? onSaved;

  const CustomTextFormField(
      {super.key,
      this.controller,
      this.width,
      this.height,
      this.suffixText,
      this.icon,
      this.hintText,
      this.borderRadius,
      this.labelText,
      this.initialValue,
      this.validator,
      this.keyboardType,
      this.autovalidateMode,
      this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: TextFormField(
        autovalidateMode: autovalidateMode,
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.person_outlined,
              size: 25,
              color: primaryColor,
            ),
            hintText: hintText,
            hintStyle:
                const TextStyle(color: Color.fromARGB(255, 98, 103, 108)),
            labelText: labelText,
            labelStyle: const TextStyle(color: primaryColor),
            filled: true,
            fillColor: const Color.fromARGB(128, 206, 206, 206),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: const BorderSide(
                  color: primaryColor,
                  width: 1.2,
                )),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: const BorderSide(color: primaryColor, width: 1.4)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: const BorderSide(color: primaryColor, width: 1.4))),
        validator: validator,
      ),
    );
  }
}
