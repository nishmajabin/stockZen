import 'package:flutter/material.dart';
import 'package:stockzen/models/product_model.dart';

class AddSaleContainer extends StatelessWidget {
  const AddSaleContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
    );
  }
}
class SelectedProduct {
  final ProductModel product;
  final int quantity;
  final double updatedPrice;

  SelectedProduct({
    required this.product,
    required this.quantity,
    required this.updatedPrice,
  });
}