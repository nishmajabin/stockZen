import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stockzen/Screens/product/products_viewing_categorised.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/category_db.dart';
import 'package:stockzen/models/category_model.dart';
import 'package:stockzen/models/product_model.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  List<CategoryModel> categories = [];
  final CategoryDB _categoryDbFunction = CategoryDB();
  bool _isLoadingCategory = true;
  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() async {
    setState(() {
      _isLoadingCategory = true;
    });

    try {
      final fetchedCategories = _categoryDbFunction.getCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      setState(() {
        _isLoadingCategory = false;
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
              'All Categories',
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
        ),
      ),
      body: _isLoadingCategory
          ? const Center(child: CircularProgressIndicator())
          : categories.isEmpty
              ? const Center(
                  child: Text(
                    'No categories added yet!',
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
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => ProductsViewingScreen(
                                      categoryID: categories[index].id,
                                      categoryName: categories[index].name)));
                        },
                        child: buildCategoryCard(
                          categories[index].name,
                          categories[index].imagePath,
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget buildCategoryCard(String title, String imagepath) {
    return GestureDetector(
      
      child: Card(
        color: const Color.fromARGB(199, 7, 46, 74),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.file(
                File(imagepath),
                height: 155,
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6.5),
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
