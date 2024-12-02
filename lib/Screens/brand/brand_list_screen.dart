import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stockzen/Screens/product/products_brands.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/brand_db.dart';
import 'package:stockzen/models/brand_model.dart';
import 'package:stockzen/models/product_model.dart';

class BrandListScreen extends StatefulWidget {
  const BrandListScreen({super.key});

  @override
  State<BrandListScreen> createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {
  List<BrandModel> brands = [];
  final BrandDb _brandDbFunction = BrandDb();
  bool _isLoadingBrands = true;
  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();
    _fetchBrands();
  }

  void _fetchBrands() async {
    setState(() {
      _isLoadingBrands = true;
    });
    try {
      final fetchedBrands = _brandDbFunction.getBrands();
      setState(() {
        brands = fetchedBrands;
      });
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      setState(() {
        _isLoadingBrands = false;
      });
    }
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
              'All Brands',
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
        ),
      ),
      body: _isLoadingBrands
          ? const Center(child: CircularProgressIndicator())
          : brands.isEmpty
              ? const Center(
                  child: Text(
                    'No Brands added yet!',
                    style: TextStyle(color: primaryColor, fontSize: 16),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: brands.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => ProductsViewingBrandScreen(
                                      brandID: brands[index].id,
                                      brandName: brands[index].name)));
                        },
                        child: _buildCategoryCard(
                          brands[index].name,
                          brands[index].imagePath,
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildCategoryCard(String title, String imagepath) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(
            File(imagepath),
            height: 130,
            width: 130,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.category,
                size: 48,
                color: primaryColor,
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
