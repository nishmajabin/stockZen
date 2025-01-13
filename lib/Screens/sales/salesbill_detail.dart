import 'package:flutter/material.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/models/sales_model.dart';
import 'package:stockzen/screens/custom_appbar.dart';

class SaleDetailsPage extends StatefulWidget {
  final SalesModel sale;

  const SaleDetailsPage({super.key, required this.sale});

  @override
  State<SaleDetailsPage> createState() => _SaleDetailsPageState();
}

class _SaleDetailsPageState extends State<SaleDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Sale Details'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(context),
              const SizedBox(height: 16),
              _buildProductsList(context),
              const SizedBox(height: 16),
              _buildTotalAmount(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      color: const Color.fromARGB(231, 203, 225, 241),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sale Information',
                style: Theme.of(context).textTheme.headlineMedium),
            const Divider(
              color: white,
            ),
            _buildInfoRow('Date', widget.sale.date.toString()),
            _buildInfoRow('Customer Name', widget.sale.customerName),
            _buildInfoRow('Customer Number', widget.sale.customerNumber),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildProductsList(BuildContext context) {
    return Card(
      elevation: 2,
      color: const Color.fromARGB(231, 203, 225, 241),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Products',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.sale.products.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              color: white,
            ),
            itemBuilder: (context, index) {
              final product = widget.sale.products[index];
              final quantity = widget.sale.getQuantityForProduct(product.id);
              return ListTile(
                title: Text(product.name),
                subtitle: Text('Price: \$${product.price}'),
                trailing: Text('Qty: $quantity'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalAmount(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF4CAF50),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Amount',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
            ),
            Text(
              '₹${widget.sale.totalAmount ?? 0.0}',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
