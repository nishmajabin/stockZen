import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockzen/Screens/custom_appbar.dart';
import 'package:stockzen/Screens/product/widgets/custom_dropdown.dart';
import 'package:stockzen/Screens/product/widgets/custom_text.dart';
import 'package:stockzen/Screens/profile/edit_profile/widgets/text_form.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/brand_db.dart';
import 'package:stockzen/functions/category_db.dart';
import 'package:stockzen/functions/product_db.dart';
import 'package:stockzen/models/brand_model.dart';
import 'package:stockzen/models/category_model.dart';
import 'package:stockzen/models/product_model.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? selectedCategory;
  List<CategoryModel> categories = [];
  final CategoryDB _categoryDbFunction = CategoryDB();
  bool _isLoadingCategory = true;
  String? selectedBrand;
  List<BrandModel> brands = [];
  final BrandDb _brandDbFunction = BrandDb();
  bool _isLoadingBrands = true;
  File? _pickedImage;
  String? brandId;
  String? categoryId;

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadBrands();
  }

  void _loadCategories() async {
    categories = _categoryDbFunction.getCategories();
    setState(() {
      _isLoadingCategory = false;
    });
  }

  void _loadBrands() async {
    brands = _brandDbFunction.getBrands();
    setState(() {
      _isLoadingBrands = false;
    });
  }

  Future<void> saveProduct() async {
    if (categoryId == null || brandId == null || _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields.")),
      );
      return;
    }
    final String productId = DateTime.now().microsecondsSinceEpoch.toString();
    final product = ProductModel(
      name: _productController.text,
      category: categoryId!,
      brand: brandId!,
      imagePath: _pickedImage!.path,
      color: _colorController.text,
      quantity: int.tryParse(_quantityController.text) ?? 0,
      price: double.tryParse(_priceController.text) ?? 0.0,
      description: _descriptionController.text,
      id: productId,
    );
    await ProductDb().addProduct(product);
    Navigator.pop(context, 1);
  }

  void _showSourceChoice() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                iconColor: primaryColor,
                textColor: primaryColor,
                onTap: () {
                  Navigator.of(context).pop();
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                iconColor: primaryColor,
                textColor: primaryColor,
                onTap: () {
                  Navigator.of(context).pop();
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Add Product',
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 35,
              ),
              CustomTextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _productController,
                icon: Icons.shopping_bag,
                hintText: 'Enter Product Name',
                labelText: 'Product Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please add product name';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const CustomText(text: 'Category:'),
              CustomDropDown(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _categoryController,
                icon: Icons.category,
                value: categoryId,
                onChanged: (newValue) {
                  setState(() {
                    categoryId = newValue;
                    _categoryController.text = newValue ?? '';
                  });
                },
                dropdownItems: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const CustomText(text: 'Brand:'),
              CustomDropDown(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _brandController,
                icon: Icons.branding_watermark,
                value: brandId,
                onChanged: (newValue) {
                  setState(() {
                    brandId = newValue;
                    _brandController.text = newValue ?? '';
                  });
                },
                dropdownItems: brands.map((brand) {
                  return DropdownMenuItem<String>(
                    value: brand.id,
                    child: Text(brand.name),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a brand';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 35),
                    child: Text(
                      'Product Image:',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 35),
                child: GestureDetector(
                  onTap: _showSourceChoice,
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(128, 206, 206, 206),
                    ),
                    child: _pickedImage != null
                        ? Image.file(_pickedImage!, fit: BoxFit.cover)
                        : const Icon(
                            Icons.add_a_photo,
                            size: 40,
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _colorController,
                icon: Icons.color_lens,
                hintText: 'Enter Color',
                labelText: 'Color',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter color';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _quantityController,
                icon: Icons.inventory_2,
                hintText: 'Enter Quantity',
                labelText: 'Quantity',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _priceController,
                icon: Icons.attach_money,
                hintText: 'Enter price',
                labelText: 'Price',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _descriptionController,
                icon: Icons.description,
                hintText: 'Enter Description',
                labelText: 'Description',
                maxLines: null,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please add description';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [primaryColor, primaryColor2],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _pickedImage != null) {
                        saveProduct();
                        log('hello>>>>>>>>>>>>>>>>>>>>>>>>>');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Please Add image as well.',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            duration: const Duration(seconds: 2),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        );
                      }
                    },
                    label: const Text(
                      'Save Product',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    icon: const Icon(Icons.save, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
