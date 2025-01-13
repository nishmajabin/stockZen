// lib/screens/sales/add_sale_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stockzen/screens/custom_appbar.dart';
import 'package:stockzen/screens/sales/widgets/sale_form_fields.dart';
import 'package:stockzen/screens/sales/widgets/product_selection_sheet.dart';
import 'package:stockzen/screens/sales/widgets/selected_products_list.dart';
import 'package:stockzen/screens/sales/widgets/total_amount_display.dart';
import 'package:stockzen/screens/sales/widgets/custom_elevated_button.dart';
import 'package:stockzen/models/sales_model.dart';
import 'package:stockzen/functions/sales_db.dart';
import 'package:stockzen/functions/product_db.dart';

class AddSaleScreen extends StatefulWidget {
  const AddSaleScreen({super.key});

  @override
  _AddSaleScreenState createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends State<AddSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _customerNumberController = TextEditingController();
  List<SelectedProduct> selectedProducts = [];
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd-MMM-yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    _dateController.dispose();
    _customerNameController.dispose();
    _customerNumberController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    setState(() {
      _totalAmount = selectedProducts.fold(
        0.0,
        (sum, item) => sum + (item.updatedPrice * item.quantity),
      );
    });
  }

  void handleProductAdd(SelectedProduct product) {
    setState(() {
      selectedProducts.add(product);
      _calculateTotal();
    });
  }

  void _handleProductRemove(int index) {
    setState(() {
      selectedProducts.removeAt(index);
      _calculateTotal();
    });
  }

  void _submitSale() async {
    if (_formKey.currentState?.validate() ?? false) {
      Map<String, int> quantities = {};
      for (var sp in selectedProducts) {
        quantities[sp.product.id] = sp.quantity;
      }

      final sale = SalesModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: _dateController.text,
        customerName: _customerNameController.text,
        customerNumber: _customerNumberController.text,
        products: selectedProducts.map((sp) => sp.product).toList(),
        totalAmount: _totalAmount,
        productQuantities: quantities,
      );

      await ProductDb().updateCountOfProduct(selectedProducts);
      await addSale(sale);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Sale added successfully!'),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Add Sale'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SaleFormFields(
                dateController: _dateController,
                customerNameController: _customerNameController,
                customerNumberController: _customerNumberController,
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: () async {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                    ),
                    builder: (context) => ProductSelectionSheet(
                      onProductSelected: handleProductAdd,
                    ),
                  );
                },
                text: 'Add Product',
                width: 250,
              ),
              const SizedBox(height: 20),
              SelectedProductsList(
                selectedProducts: selectedProducts,
                onRemove: _handleProductRemove,
              ),
              TotalAmountDisplay(amount: _totalAmount),
              const SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: _submitSale,
                text: 'Submit Sale',
                width: 300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}