import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stockzen/Screens/brand/edit_brand_screen.dart';
import 'package:stockzen/Screens/category/edit_category_screen.dart';
import 'package:stockzen/Screens/product/edit_product_screen.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/product_db.dart';
import 'package:stockzen/models/brand_model.dart';
import 'package:stockzen/models/category_model.dart';
import 'package:stockzen/models/product_model.dart';

class CustomCard extends StatefulWidget {
  final int index;
  final dynamic product; // Use dynamic to handle multiple model types
  final Type model;
  final String title;
  final String imagePath;

  const CustomCard({
    super.key,
    required this.index,
    required this.product,
    required this.model,
    required this.title,
    required this.imagePath,
  });

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  final ProductDb _productDbFunction = ProductDb(); // Ensure this class exists
  bool _isLoadingProducts = false;
  List<ProductModel> products = [];

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoadingProducts = true;
    });
    try {
      final fetchedProducts = await _productDbFunction.getProduct();
      setState(() {
        products = fetchedProducts;
      });
    } catch (e) {
      debugPrint("Error fetching products: $e");
    } finally {
      setState(() {
        _isLoadingProducts = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 4,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.file(
              File(widget.imagePath),
              height: 140,
              width: 140,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.withOpacity(0.2),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.category,
                    size: 48,
                    color: Colors.grey,
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(1),
                ],
              )),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Theme(
                data: Theme.of(context).copyWith(
                  popupMenuTheme: const PopupMenuThemeData(
                    color: primaryColor,
                    textStyle: TextStyle(color: Colors.white),
                  ),
                ),
                child: PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  offset: const Offset(-90, 5),
                  onSelected: (value) {
                    if (value == 'Edit') {
                      if (widget.model == CategoryModel) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => EditCategoryScreen(
                              category: widget.product,
                            ),
                          ),
                        );
                      } else if (widget.model == BrandModel) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => EditBrandScreen(
                              brand: widget.product,
                            ),
                          ),
                        );
                      } else if (widget.model == ProductModel) {
                        final ProductModel newProduct = widget.product;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => EditProductScreen(
                              product: newProduct,
                              productKey: newProduct.id,
                              productName: newProduct.name,
                              brand: newProduct.brand,
                              category: newProduct.category,
                              image: newProduct.imagePath,
                              color: newProduct.color,
                              quantity: newProduct.quantity,
                              price: newProduct.price,
                              description: newProduct.description,
                            ),
                          ),
                        );
                      } else {
                        debugPrint('Nothing selected');
                      }
                    } else if (value == 'Delete') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Delete Product'),
                            content: const Text(
                                'Are you sure you want to delete this product?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel',
                                    style: TextStyle(color: Colors.grey)),
                              ),
                              TextButton(
                                onPressed: () {
                                  ProductDb().deleteProduct(widget.product.id);
                                  _fetchProducts();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Delete',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: 'Edit',
                      child: ListTile(
                        leading: Icon(Icons.edit, color: Colors.white),
                        title:
                            Text('Edit', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'Delete',
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.white),
                        title: Text('Delete',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
