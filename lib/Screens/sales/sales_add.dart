import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stockzen/Screens/profile/edit_profile/widgets/text_form.dart';
import 'package:stockzen/Screens/sales/widgets/sales_save.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/category_db.dart';
import 'package:stockzen/functions/product_db.dart';
import 'package:stockzen/functions/sales_db.dart';
import 'package:stockzen/models/category_model.dart';
import 'package:stockzen/models/product_model.dart';
import 'package:stockzen/models/sales_model.dart';

class AddSaleScreen extends StatefulWidget {
  const AddSaleScreen({Key? key}) : super(key: key);

  @override
  _AddSaleScreenState createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends State<AddSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _customernameController = TextEditingController();
  final _customernumberController = TextEditingController();

  ProductModel? _selectedProduct;
  List<ProductModel> products = [];
  List<CategoryModel> categories = [];
  String? selectedCategory;
  List<SelectedProduct> _selectedProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchCategories();
    _dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    _dateController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _customernameController.dispose();
    _customernumberController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    final fetchedProducts = await ProductDb().getProduct();
    if (fetchedProducts != null) {
      setState(() {
        products = fetchedProducts;
      });
    }
  }

  Future<void> _fetchCategories() async {
    final fetchedCategories = await CategoryDB().getCategories();
    if (fetchedCategories != null) {
      setState(() {
        categories = fetchedCategories;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  void submitSale() async {
    if (_formKey.currentState?.validate() ?? false) {
      final sale = SalesModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: _dateController.text,
        customerName: _customernameController.text,
        customerNumber: _customernumberController.text,
        products: _selectedProducts
            .map((sp) => ProductModel(
                  productName: sp.product.productName,
                  productImagePath: sp.product.productImagePath,
                  id: sp.product.id,
                  category: sp.product.category,
                  brand: sp.product.brand,
                  color: sp.product.color,
                  price: sp.updatedPrice,
                  quantity: sp
                      .quantity, // Ensure to assign the quantity entered by the user
                  description: sp.product.description,
                ))
            .toList(),

        saleQuantity: _selectedProducts.fold(0, (sum, sp) => sum + sp.quantity),
        totalAmount: null, // Total quantity of all products
      );

      await addSale(sale);

      _showSnackBar('Sale added successfully');
      Navigator.pop(context, true);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        title: const Text('Add Sale', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                controller: _dateController,
                labelText: 'Date',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.datetime,
                onTap: _selectDate,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _customernameController,
                  labelText: 'Customer Name',
                  icon: Icons.person,
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  } else {
                    return null;
                  }
                },
                  ),
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _customernumberController,
                  labelText: 'Mobile Number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter customer's number";
                  } else {
                    return null;
                  }
                },
                  ),
              SizedBox(
                height: 40,
              ),
              CustomTextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _quantityController,
                  labelText: 'Quantity',
                  icon: Icons.confirmation_number,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  } else {
                    return null;
                  }
                },
                  ),
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _priceController,
                  labelText: 'Price',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  } else {
                    return null;
                  }
                },
                  ),
              const SizedBox(height: 16),
              SizedBox(height: 16),
              const SizedBox(height: 24),
              SubmitButton(
                function: submitSale,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectedProduct {
  ProductModel product;
  int quantity;
  double updatedPrice;

  SelectedProduct({
    required this.product,
    required this.quantity,
    required this.updatedPrice,
  });
}
