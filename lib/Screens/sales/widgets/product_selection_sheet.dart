import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stockzen/functions/product_db.dart';
import 'package:stockzen/models/product_model.dart';
import 'package:stockzen/screens/sales/widgets/selected_products_list.dart';

class ProductSelectionSheet extends StatefulWidget {
  final void Function(SelectedProduct) onProductSelected;

  const ProductSelectionSheet({
    super.key,
    required this.onProductSelected,
  });

  @override
  _ProductSelectionSheetState createState() => _ProductSelectionSheetState();
}

class _ProductSelectionSheetState extends State<ProductSelectionSheet> {
  final searchController = TextEditingController();
  List<ProductModel> products = [];
  List<ProductModel> filteredProducts = [];
  String? _quantityErrorText;

  @override
  void initState() {
    super.initState();
    products = ProductDb().getProduct();
    filteredProducts = List.from(products);
  }

  void _handleSearch(String value) {
    setState(() {
      filteredProducts = products
          .where((product) =>
              product.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future<void> _showQuantityDialog(ProductModel product) async {
    int quantity = 1;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Quantity'),
          content: TextField(
            decoration: InputDecoration(
              labelText: 'Quantity',
              errorText: _quantityErrorText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final enteredQuantity = int.tryParse(value) ?? 1;
              setState(() {
                if (product.quantity >= enteredQuantity) {
                  quantity = enteredQuantity;
                  _quantityErrorText = null;
                } else {
                  _quantityErrorText =
                      'Not enough stock available. Only ${product.quantity} left.';
                }
              });
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (_quantityErrorText == null) {
                  widget.onProductSelected(SelectedProduct(
                    product: product,
                    quantity: quantity,
                    updatedPrice: product.price,
                  ));
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Product',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSearchField(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildProductList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search Products',
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              searchController.clear();
              setState(() {
                filteredProducts = List.from(products);
              });
            },
          ),
        ),
        onChanged: _handleSearch,
      ),
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildProductTile(product);
      },
    );
  }

  Widget _buildProductTile(ProductModel product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(File(product.imagePath)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price: ₹${product.price.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Stock: ${product.quantity}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () => _showQuantityDialog(product),
      ),
    );
  }
}