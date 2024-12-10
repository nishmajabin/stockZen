import 'package:flutter/material.dart';
import 'package:stockzen/constant.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback addProduct;
  const CustomButton({
    super.key,
    required this.addProduct,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: addProduct,
      style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12)),
      child: const Text(
        'Add Product',
        style: TextStyle(
          fontSize: 16, // Text size
          fontWeight: FontWeight.w500, // Semi-bold text
          color: Colors.white, // Text color
        ),
      ),
    );
  }
}