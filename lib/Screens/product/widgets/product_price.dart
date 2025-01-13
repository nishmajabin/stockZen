import 'package:flutter/material.dart';
import 'package:stockzen/constant.dart';

class ProductPriceWidget extends StatelessWidget {
  final double price;
  final EdgeInsetsGeometry? padding;
  final TextStyle? priceStyle;

  const ProductPriceWidget({
    Key? key,
    required this.price,
    this.padding = const EdgeInsets.all(16),
    this.priceStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      alignment: Alignment.center,
      child: Text(
        '₹${price.toStringAsFixed(1)}',
        style: priceStyle ??
            const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: priceColor,
            ),
      ),
    );
  }
}
