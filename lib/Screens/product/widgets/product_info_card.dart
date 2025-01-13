import 'package:flutter/material.dart';
import 'package:stockzen/constant.dart';

class ProductInfoCard extends StatelessWidget {
  final String brand;
  final String category;
  final String color;
  final int quantity;

  const ProductInfoCard({
    Key? key,
    required this.brand,
    required this.category,
    required this.color,
    required this.quantity,
  }) : super(key: key);

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(200, 102, 137, 162),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildInfoRow('Brand', brand),
          const SizedBox(height: 8),
          _buildInfoRow('Category', category),
          const SizedBox(height: 8),
          _buildInfoRow('Color', color),
          const SizedBox(height: 8),
          _buildInfoRow('Quantity', quantity.toString()),
        ],
      ),
    );
  }
}
