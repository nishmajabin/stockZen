
import 'package:flutter/material.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/models/sales_model.dart';

class SaleDetailsPage extends StatefulWidget {
  final SalesModel sale;

  SaleDetailsPage({required this.sale});

  @override
  State<SaleDetailsPage> createState() => _SaleDetailsPageState();
}

class _SaleDetailsPageState extends State<SaleDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        title: const Text(
          'Sale Details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(context),
              SizedBox(height: 16),
              _buildProductsList(context),
              SizedBox(height: 16),
              _buildTotalAmount(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sale Information',
                style: Theme.of(context).textTheme.headlineMedium),
            Divider(),
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
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildProductsList(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Text('Products', style: Theme.of(context).textTheme.titleLarge),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.sale.products.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final product = widget.sale.products[index];
              final salesQuantity = widget.sale.saleQuantity;

              // print('Product: ${product.name}, Quantity: ${product.quantity}');

              return ListTile(
                title: Text(product.name),
                subtitle: Text('Price: \$${product.price}'),
                trailing: Text('Qty: ${salesQuantity}'),
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
      color: Color(0xFF4CAF50),
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
              '\₹${widget.sale.totalAmount ?? 0.0}',
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
