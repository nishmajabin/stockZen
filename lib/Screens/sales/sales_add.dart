import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:stockzen/Screens/custom_appbar.dart';
import 'package:stockzen/Screens/profile/edit_profile/widgets/text_form.dart';
import 'package:stockzen/functions/product_db.dart';
import 'package:stockzen/models/product_model.dart';
import 'package:stockzen/models/sales_model.dart';
import 'package:stockzen/functions/sales_db.dart';
import 'package:stockzen/constant.dart';

class AddSaleScreen extends StatefulWidget {
  const AddSaleScreen({Key? key}) : super(key: key);

  @override
  _AddSaleScreenState createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends State<AddSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _customerNumberController = TextEditingController();
  List<SelectedProduct>selectedProducts = [];
  double _totalAmount = 0.0;
  String? _quantityErrorText;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    _dateController.dispose();
    _customerNameController.dispose();
    _customerNumberController.dispose();
    super.dispose();
  }

  void _addProduct() async {
    final products = ProductDb().getProduct();

    if (products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No products available in the database.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    ProductModel? selectedProduct;
    int quantity = 1;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Product'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<ProductModel>(
                    hint: const Text('Select Product'),
                    value: selectedProduct,
                    items: products.map((product) {
                      return DropdownMenuItem(
                        value: product,
                        child: Text(product.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProduct = value;
                      });
                    },
                  ),
                  if (selectedProduct != null) ...[
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        errorText: _quantityErrorText,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: primaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final enteredQuantity = int.tryParse(value) ?? 1;
                        if (selectedProduct != null &&
                            enteredQuantity <= selectedProduct!.quantity) {
                          setState(() {
                            quantity = enteredQuantity;
                            _quantityErrorText = null;
                          });
                        } else {
                          setState(() {
                            _quantityErrorText =
                                'Not enough stock available. Only ${selectedProduct?.quantity} left.';
                          });
                        }
                      },
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedProduct != null && _quantityErrorText == null) {
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Please select a product and enter a valid quantity.'),
                        backgroundColor: Colors.red,
                      ));
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );

    if (selectedProduct != null && _quantityErrorText == null) {
      setState(() {
        selectedProducts.add(SelectedProduct(
          product: selectedProduct!,
          quantity: quantity,
          updatedPrice: selectedProduct!.price,
        ));
        _calculateTotal();
      });
    }
  }

  void _calculateTotal() {
    _totalAmount = selectedProducts.fold(
      0.0,
      (sum, item) => sum + (item.updatedPrice * item.quantity),
    );
  }

  void _submitSale() async {
    if (_formKey.currentState?.validate() ?? false) {
      final sale = SalesModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: _dateController.text,
        customerName: _customerNameController.text,
        customerNumber: _customerNumberController.text,
        products: selectedProducts.map((sp) => sp.product).toList(),
        saleQuantity: selectedProducts.fold(0, (sum, sp) => sum + sp.quantity),
        totalAmount: _totalAmount,
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
              CustomTextFormField(
                controller: _dateController,
                labelText: 'Date',
                icon: Icons.calendar_month,
                readOnly: true,
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    _dateController.text =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _customerNameController,
                icon: Icons.person,
                labelText: 'Customer Name',
                hintText: 'Enter Customer Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter customer's name";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _customerNumberController,
                icon: Icons.phone,
                labelText: 'Mobile Number',
                hintText: "Enter customer's number",
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter customer's name";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: _addProduct,
                text: 'Add Product',
                width: 250,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedProducts.length,
                  itemBuilder: (context, index) {
                    final product = selectedProducts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        title: Text(product.product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          'Quantity: ${product.quantity}, Price: \$${product.updatedPrice.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              selectedProducts.removeAt(index);
                              _calculateTotal();
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Text(
                'Total: \$${_totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
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

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double? width;
  CustomElevatedButton(
      {required this.onPressed, required this.text, this.width});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryColor, primaryColor2],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 15),
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
