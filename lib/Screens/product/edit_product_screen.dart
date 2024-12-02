import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/brand_db.dart';
import 'package:stockzen/functions/category_db.dart';
import 'package:stockzen/functions/product_db.dart';
import 'package:stockzen/models/brand_model.dart';
import 'package:stockzen/models/category_model.dart';
import 'package:stockzen/models/product_model.dart';

class EditProductScreen extends StatefulWidget {
  final String productKey;
  final String productName;
  final String brand;
  final String category;
  final String image;
  final String color;
  final String quantity;
  final String price;
  final String description;
  const EditProductScreen({
    super.key,
    required this.productKey,
    required this.productName,
    required this.brand,
    required this.category,
    required this.image,
    required this.color,
    required this.quantity,
    required this.price,
    required this.description,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _editProductController = TextEditingController();
  late TextEditingController _editCategoryController = TextEditingController();
  late TextEditingController _editBrandController = TextEditingController();
  late TextEditingController _editColorController = TextEditingController();
  late TextEditingController _editQuantityController = TextEditingController();
  late TextEditingController _editPriceController = TextEditingController();
  late TextEditingController _editDescriptionController =
      TextEditingController();

  String? selectedCategory;
  List<CategoryModel> categories = [];
  final CategoryDB _categoryDbFunction = CategoryDB();
  bool _isLoadingCategory = true;
  List<BrandModel> brands = [];
  String? selectedBrand;

  final BrandDb _brandDbFunction = BrandDb();
  bool _isLoadingBrands = true;
  File? _pickedImage;
  String? image;

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
    _editProductController = TextEditingController();
    _editCategoryController = TextEditingController();
    _editBrandController = TextEditingController();
    _editColorController = TextEditingController();
    _editQuantityController = TextEditingController();
    _editPriceController = TextEditingController();
    _editDescriptionController = TextEditingController();
    _loadCategories();
    _loadBrands();
    fetchAddedProduct();
  }

  void _loadCategories() async {
    categories = _categoryDbFunction.getCategories();
    log(categories.first.name);
    setState(() {
      selectedCategory = widget.category;
      _isLoadingCategory = false;
    });
  }

  void _loadBrands() async {
    brands = _brandDbFunction.getBrands();
    setState(() {
      selectedBrand = widget.brand;
      _isLoadingBrands = false;
    });
  }

  Future<void> fetchAddedProduct() async {
    // final editProduct = await ProductDb().getProduct();
    log('Received Image Path: ${widget.category}');
    setState(() {
      _editProductController.text = widget.productName;
      _editCategoryController.text = widget.category;
      _editBrandController.text = widget.brand;
      _editColorController.text = widget.color;
      _editQuantityController.text = widget.quantity;

      _editPriceController.text = widget.price;
      _editDescriptionController.text = widget.description;
      image = widget.image;
    });
  }

  Future<void> updatedProduct(String productKey) async {
    log('worked11111111');
    final editedProduct = await ProductModel(
        productName: _editProductController.text,
        category: _editCategoryController.text,
        brand: _editBrandController.text,
        productImagePath: _pickedImage?.path ?? image!,
        color: _editColorController.text,
        quantity: _editQuantityController.text,
        price: _editPriceController.text,
        description: _editDescriptionController.text,
        id: '');
    ProductDb().updateProduct(productKey, editedProduct);
    log('worked');

    Navigator.pop(context, editedProduct);
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
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [primaryColor, primaryColor2],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight)),
          child: AppBar(
            title: const Text(
              'Edit Product',
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 35),
                child: TextFormField(
                  controller: _editProductController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.shopping_bag,
                        size: 25,
                        color: primaryColor,
                      ),
                      hintText: 'Enter Product Name',
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 98, 103, 108)),
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
                          borderSide: const BorderSide(
                              color: primaryColor, width: 1.4)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                              color: primaryColor, width: 1.4)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                              color: primaryColor, width: 1.4))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please add product name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 35),
                    child: Text(
                      'Category:',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 35),
                child: TextFormField(
                  controller: _editCategoryController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.category,
                        size: 25,
                        color: primaryColor,
                      ),
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
                            icon: const Padding(
                              padding: EdgeInsets.only(right: 9),
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: primaryColor,
                                size: 28,
                              ),
                            ),
                            value: selectedCategory ?? 'nishma',
                            onChanged: (newValue) {
                              setState(() {
                                selectedCategory = newValue;
                                _editCategoryController.text = newValue!;
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
                          borderSide: const BorderSide(
                              color: primaryColor, width: 1.4)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                              color: primaryColor, width: 1.4)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                              color: primaryColor, width: 1.4))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select category';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 35),
                    child: Text(
                      'Brand:',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 35),
                child: TextFormField(
                  controller: _editBrandController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.branding_watermark,
                        size: 25,
                        color: primaryColor,
                      ),
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
                            icon: const Padding(
                              padding: EdgeInsets.only(right: 9),
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: primaryColor,
                                size: 28,
                              ),
                            ),
                            value: selectedBrand ?? 'siuyad',
                            onChanged: (newValue) {
                              setState(() {
                                selectedBrand = newValue;
                                _editBrandController.text = newValue!;
                              });
                            },
                            items: brands.map((brand) {
                              return DropdownMenuItem<String>(
                                value: brand.name,
                                child: Text(brand.name),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                              color: primaryColor, width: 1.4)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                              color: primaryColor, width: 1.4)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                              color: primaryColor, width: 1.4))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select brand';
                    }
                    return null;
                  },
                ),
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
                        : widget.image != null && widget.image.isNotEmpty
                            ? Image.file(File(widget.image), fit: BoxFit.cover)
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
              // Padding(
              //   padding: const EdgeInsets.only(left: 35, right: 35),
              //   child: TextFormField(
              //     controller: _editColorController,
              //     autovalidateMode: AutovalidateMode.onUserInteraction,
              //     decoration: InputDecoration(
              //         prefixIcon: const Icon(
              //           Icons.color_lens,
              //           size: 25,
              //           color: primaryColor,
              //         ),
              //         hintText: 'Enter Color',
              //         hintStyle: const TextStyle(
              //             color: Color.fromARGB(255, 98, 103, 108)),
              //         labelText: 'Color',
              //         labelStyle: const TextStyle(color: primaryColor),
              //         filled: true,
              //         fillColor: const Color.fromARGB(128, 206, 206, 206),
              //         enabledBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(7),
              //             borderSide: const BorderSide(
              //               color: primaryColor,
              //               width: 1.2,
              //             )),
              //         focusedBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(7),
              //             borderSide: const BorderSide(
              //                 color: primaryColor, width: 1.4)),
              //         errorBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(7),
              //             borderSide: const BorderSide(
              //                 color: primaryColor, width: 1.4)),
              //         focusedErrorBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(7),
              //             borderSide: const BorderSide(
              //                 color: primaryColor, width: 1.4))),
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please enter color';
              //       }
              //       return null;
              //     },
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 35, right: 35),
              //   child: TextFormField(
              //     controller: _editQuantityController,
              //     autovalidateMode: AutovalidateMode.onUserInteraction,
              //     decoration: InputDecoration(
              //         prefixIcon: const Icon(
              //           Icons.inventory_2,
              //           size: 25,
              //           color: primaryColor,
              //         ),
              //         hintText: 'Enter Quantity',
              //         hintStyle: const TextStyle(
              //             color: Color.fromARGB(255, 98, 103, 108)),
              //         labelText: 'Quantity',
              //         labelStyle: const TextStyle(color: primaryColor),
              //         filled: true,
              //         fillColor: const Color.fromARGB(128, 206, 206, 206),
              //         enabledBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(7),
              //             borderSide: const BorderSide(
              //               color: primaryColor,
              //               width: 1.2,
              //             )),
              //         focusedBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(7),
              //             borderSide: const BorderSide(
              //                 color: primaryColor, width: 1.4)),
              //         errorBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(7),
              //             borderSide: const BorderSide(
              //                 color: primaryColor, width: 1.4)),
              //         focusedErrorBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(7),
              //             borderSide: const BorderSide(
              //                 color: primaryColor, width: 1.4))),
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please enter quantity';
              //       }
              //       return null;
              //     },
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 35),
                child: TextFormField(
                  controller: _editPriceController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.attach_money,
                        size: 25,
                        color: primaryColor,
                      ),
                      hintText: 'Enter Price',
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 98, 103, 108)),
                      labelText: 'Price',
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
                          borderSide: const BorderSide(
                              color: primaryColor, width: 1.4)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                              color: primaryColor, width: 1.4)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                              color: primaryColor, width: 1.4))),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter price';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 35),
                child: TextFormField(
                  controller: _editDescriptionController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.description,
                        size: 25,
                        color: primaryColor,
                      ),
                      hintText: 'Add description',
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 98, 103, 108)),
                      labelText: 'Description',
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
                          borderSide: const BorderSide(
                              color: primaryColor, width: 1.4)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                              color: primaryColor, width: 1.4)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                              color: primaryColor, width: 1.4))),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Add description';
                    }
                    return null;
                  },
                ),
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
                      if (_formKey.currentState!.validate()) {
                        updatedProduct(widget.productKey);
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
                      'Update Product',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}