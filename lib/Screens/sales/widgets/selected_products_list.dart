import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stockzen/models/product_model.dart';

class SelectedProductsList extends StatelessWidget {
  final List<SelectedProduct> selectedProducts;
  final Function(int) onRemove;

  const SelectedProductsList({
    super.key,
    required this.selectedProducts,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: selectedProducts.length,
        itemBuilder: (context, index) {
          final product = selectedProducts[index];
          return Card(
            color: const Color.fromARGB(198, 213, 237, 253),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: FileImage(File(product.product.imagePath)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                product.product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Quantity: ${product.quantity}, Price: \$${product.updatedPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 56, 55, 55),
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 153, 31, 22),
                ),
                onPressed: () => onRemove(index),
              ),
            ),
          );
        },
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