import 'package:flutter/material.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/brand_db.dart';
import 'package:stockzen/functions/category_db.dart';
import 'package:stockzen/functions/product_db.dart';
import 'package:stockzen/models/product_model.dart';
import 'package:stockzen/screens/product/edit_product_screen.dart';
import 'dart:io';

import 'package:stockzen/screens/product/widgets/custom_info_card.dart';
import 'package:stockzen/screens/product/widgets/product_description.dart';
import 'package:stockzen/screens/product/widgets/product_price.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailsScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsScreen> {
  late ProductModel product;
  String? categoryName;
  String? brandName;

  @override
  void initState() {
    super.initState();
    product = widget.product;
    getProduct();
    _loadBrands();
    _loadCategories();
  }

  void _loadCategories() async {
    final categories = CategoryDB().getCategories();
    final category =
        categories.firstWhere((value) => value.id == widget.product.category);
    categoryName = category.name;
    setState(() {});
  }

  void _loadBrands() async {
    final brands = BrandDb().getBrands();
    final currentBrand =
        brands.firstWhere((brand) => brand.id == widget.product.brand);
    brandName = currentBrand.name;
    setState(() {});
  }

  Future<void> getProduct() async {
    product = await ProductDb().getProductById(widget.product.id);
  }

  void _navigateToEditPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => EditProductScreen(
          product: product,
          productName: product.name,
          brand: product.brand,
          category: product.category,
          image: product.imagePath,
          color: product.color,
          quantity: product.quantity,
          price: product.price,
          description: product.description,
          productKey: product.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Colors.grey[300],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: primaryColor, size: 24),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(10, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        File(product.imagePath),
                        fit: BoxFit.cover,
                      ),
                      // Gradient overlay for better text visibility
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                      // Product name container
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          child: Text(
                            product.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 3),
                                  blurRadius: 4,
                                  color: Colors.black45,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductPriceWidget(price: product.price),
                Column(
                  children: [
                    CustomInfoRow(
                      label: 'Brand',
                      value: brandName ?? product.brand,
                    ),
                    const SizedBox(height: 15),
                    CustomInfoRow(
                        label: 'Category',
                        value: categoryName ?? product.category),
                    const SizedBox(height: 15),
                    CustomInfoRow(label: 'Color', value: product.color),
                    const SizedBox(height: 15),
                    CustomInfoRow(
                        label: 'Quantity', value: product.quantity.toString()),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ProductDescriptionWidget(
                  description: product.description,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToEditPage,
        backgroundColor: primaryColor,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}
