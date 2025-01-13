import 'package:flutter/material.dart';
import 'package:stockzen/constant.dart';

class TotalAmountDisplay extends StatelessWidget {
  final double amount;

  const TotalAmountDisplay({
    super.key,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Total: \$${amount.toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
    );
  }
}