import 'package:flutter/material.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/models/product_model.dart';

class StockSummaryWidget extends StatelessWidget {
  final List<ProductModel> products;

  const StockSummaryWidget({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalProducts = products.length;
    final outOfStock = products.where((p) => p.quantity == 0).length;
    final lowStock =
        products.where((p) => p.quantity <= 5 && p.quantity > 0).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 4,
        color: const Color.fromARGB(167, 191, 228, 255),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SummaryItem('Total Products', totalProducts, Colors.green),
              SummaryItem('Out of Stock', outOfStock, Colors.red),
              SummaryItem('Low Stock', lowStock, Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const SummaryItem(this.label, this.value, this.color, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value.toString(),
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
