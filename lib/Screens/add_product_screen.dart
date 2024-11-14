import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/brand_db.dart';
import 'package:stockzen/functions/category_db.dart';
import 'package:stockzen/models/brand_model.dart';
import 'package:stockzen/models/category_model.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _brandNameController = TextEditingController();

  String? selectedCategory;
  List<CategoryModel> categories = [];
  final CategoryDB _categoryDbFunction = CategoryDB();
  bool _isLoadingCategory = true;
  String? selectedBrand;
  List<BrandModel> brands = [];
  final BrandDb _brandDbFunction = BrandDb();
  bool _isLoadingBrands = true;
  File? _pickedImage;

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
    categories = await _categoryDbFunction.getCategories();
    setState(() {
      _isLoadingCategory = false;
    });
  }

  void _loadBrands() async {
    brands = await _brandDbFunction.getBrands();
    setState(() {
      _isLoadingBrands = false;
    });
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [primaryColor, primaryColor2],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight)),
          child: AppBar(
            title: Text(
              'Add Product',
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 35),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.shopping_bag,
                    size: 25,
                    color: primaryColor,
                  ),
                  hintText: 'Enter Product Name',
                  hintStyle:
                      const TextStyle(color: Color.fromARGB(255, 98, 103, 108)),
                  labelText: 'Product name',
                  labelStyle: const TextStyle(color: primaryColor),
                  filled: true,
                  fillColor: const Color.fromARGB(128, 206, 206, 206),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 1.2,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.4)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.4)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.4))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please add product name';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 35),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.category,
                    size: 25,
                    color: primaryColor,
                  ),
                  hintText: 'Select Category',
                  hintStyle:
                      const TextStyle(color: Color.fromARGB(255, 98, 103, 108)),
                  labelText: 'Category',
                  labelStyle: const TextStyle(color: primaryColor),
                  filled: true,
                  fillColor: const Color.fromARGB(128, 206, 206, 206),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 1.2,
                      )),
                  suffixIcon: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 45),
                      child: DropdownButton<String>(
                        alignment: Alignment.centerLeft,
                        isExpanded: true,
                        icon: Padding(
                          padding: const EdgeInsets.only(right: 9),
                          child: const Icon(
                            Icons.arrow_drop_down,
                            color: primaryColor,
                            size: 28,
                          ),
                        ),
                        value: selectedCategory,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        },
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category.name,
                            child: Text(category.name),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.4)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.4)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.4))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select category';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 35),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.branding_watermark,
                    size: 25,
                    color: primaryColor,
                  ),
                  hintText: 'Select Brand',
                  hintStyle:
                      const TextStyle(color: Color.fromARGB(255, 98, 103, 108)),
                  labelText: 'Brand',
                  labelStyle: const TextStyle(color: primaryColor),
                  filled: true,
                  fillColor: const Color.fromARGB(128, 206, 206, 206),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 1.2,
                      )),
                  suffixIcon: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 45),
                      child: DropdownButton<String>(
                        alignment: Alignment.centerLeft,
                        isExpanded: true,
                        icon: Padding(
                          padding: const EdgeInsets.only(right: 9),
                          child: const Icon(
                            Icons.arrow_drop_down,
                            color: primaryColor,
                            size: 28,
                          ),
                        ),
                        value: selectedBrand,
                        onChanged: (newValue) {
                          setState(() {
                            selectedBrand = newValue;
                          });
                        },
                        items: brands.map((brands) {
                          return DropdownMenuItem<String>(
                            value: brands.name,
                            child: Text(brands.name),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.4)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.4)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.4))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select brand name';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
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
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 35),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.color_lens,
                    size: 25,
                    color: primaryColor,
                  ),
                  hintText: 'Enter Color',
                  hintStyle:
                      const TextStyle(color: Color.fromARGB(255, 98, 103, 108)),
                  labelText: 'Color',
                  labelStyle: const TextStyle(color: primaryColor),
                  filled: true,
                  fillColor: const Color.fromARGB(128, 206, 206, 206),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 1.2,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.4)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.4)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.4))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter color';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 35),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.archive,
                    size: 25,
                    color: primaryColor,
                  ),
                  hintText: 'Enter Quantity',
                  hintStyle:
                      const TextStyle(color: Color.fromARGB(255, 98, 103, 108)),
                  labelText: 'Quantity',
                  labelStyle: const TextStyle(color: primaryColor),
                  filled: true,
                  fillColor: const Color.fromARGB(128, 206, 206, 206),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 1.2,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.4)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.4)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.4))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter quantity';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
