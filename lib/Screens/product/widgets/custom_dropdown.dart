// import 'package:flutter/material.dart';
// import 'package:stockzen/constant.dart';

// class CustomTextFormField extends StatelessWidget {
//   final TextEditingController? controller;
//   final double? width;
//   final double? height;
//   final String? suffixText;
//   final IconData? icon;
//   final String? hintText;
//   final int? maxLines;
//   final double? borderRadius;
//   final String? labelText;
//   final String? initialValue;
//   final String? Function(String?)? validator;
//   final TextInputType? keyboardType;
//   final AutovalidateMode? autovalidateMode;
//   final ValueChanged<String?>? onSaved;
//   final VoidCallback? onTap;

//   const CustomTextFormField(
//       {super.key,
//       this.controller,
//       this.width,
//       this.height,
//       this.suffixText,
//       this.icon,
//       this.hintText,
//       this.borderRadius,
//       this.labelText,
//       this.initialValue,
//       this.validator,
//       this.keyboardType,
//       this.autovalidateMode,
//       this.onSaved,
//       this.maxLines, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 35, right: 35),
//       child: TextFormField(
//         autovalidateMode: autovalidateMode,
//         controller: controller,
//         decoration: InputDecoration(
//             prefixIcon: Icon(
//               icon,
//               size: 25,
//               color: primaryColor,
//             ),
//             hintText: hintText,
//             hintStyle:
//                 const TextStyle(color: Color.fromARGB(255, 98, 103, 108)),
//             labelText: labelText,
//             labelStyle: const TextStyle(color: primaryColor),
//             filled: true,
//             fillColor: const Color.fromARGB(128, 206, 206, 206),
//             enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(7),
//                 borderSide: const BorderSide(
//                   color: primaryColor,
//                   width: 1.2,
//                 )),
//             errorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(7),
//                 borderSide: const BorderSide(color: primaryColor, width: 1.4)),
//             focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(7),
//                 borderSide: const BorderSide(color: primaryColor, width: 1.4))),
//         textInputAction: TextInputAction.newline,
//         onTap: onTap,
//       readOnly: onTap != null,
//         validator: validator,
//       ),
//     );
//   }

// }
import 'package:flutter/material.dart';
import 'package:stockzen/constant.dart';

class CustomDropDown extends StatelessWidget {
  final TextEditingController? controller;
  final double? width;
  final double? height;
  final String? suffixText;
  final IconData? icon;
  final String? hintText;
  final int? maxLines;
  final double? borderRadius;
  final String? labelText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String?>? onChanged;
  final VoidCallback? onTap;
  final List<DropdownMenuItem<String>>? dropdownItems;
  final String? selectedValue;
  final Text? hint;
  final String? value;

  const CustomDropDown({
    super.key,
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
    this.maxLines,
    this.onTap,
    this.dropdownItems,
    this.selectedValue,
    this.onChanged,
    this.value,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: TextFormField(
        autovalidateMode: autovalidateMode,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            size: 25,
            color: primaryColor,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 98, 103, 108)),
          labelText: labelText,
          labelStyle: const TextStyle(color: primaryColor),
          filled: true,
          fillColor: const Color.fromARGB(128, 206, 206, 206),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(
              color: primaryColor,
              width: 1.2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: primaryColor, width: 1.4),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: primaryColor, width: 1.4),
          ),
          suffixIcon: DropdownButtonHideUnderline(
            child: Padding(
              padding: const EdgeInsets.only(left: 45),
              child: DropdownButton<String>(
                alignment: Alignment.centerLeft,
                isExpanded: true,
                icon: const Padding(
                  padding: EdgeInsets.only(right: 9),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: primaryColor,
                    size: 28,
                  ),
                ),
                value: value,
                onChanged: onChanged,
                items: dropdownItems,
              ),
            ),
          ),
        ),
        // suffixIcon: dropdownItems != null
        //     ? DropdownButtonHideUnderline(
        //         child: DropdownButton<String>(
        //           isExpanded: true,
        //           alignment: Alignment.centerLeft,
        //           value: value,
        //           icon: const Icon(
        //             Icons.arrow_drop_down,
        //             color: primaryColor,
        //             size: 28,
        //           ),
        //           onChanged: onChanged,
        //           items: dropdownItems,
        //         ),
        //       )
        //     : null,

        textInputAction: TextInputAction.newline,
        onTap: onTap,
        readOnly: onTap != null,
        validator: validator,
      ),
    );
  }
}
