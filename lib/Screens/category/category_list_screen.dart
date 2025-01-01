import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stockzen/Screens/category/products_viewing_categorised.dart';
import 'package:stockzen/Screens/profile/edit_profile/widgets/text_form.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/category_db.dart';
import 'package:stockzen/models/category_model.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CategoryModel> categories = [];
  final CategoryDB _categoryDbFunction = CategoryDB();
  bool isLoadingCategory = true;
  List<CategoryModel> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _searchController.addListener(() {
      _filterCategories(_searchController.text);
    });
  }

  void _fetchCategories() async {
    setState(() {
      isLoadingCategory = true;
    });

    try {
      final fetchedCategories = await _categoryDbFunction.getCategories();
      setState(() {
        categories = fetchedCategories;
        filteredCategories = List.from(categories);
      });
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      setState(() {
        isLoadingCategory = false;
      });
    }
  }

  void _filterCategories(String query) {
    setState(() {
      filteredCategories = categories
          .where((category) =>
              (category.name.toLowerCase()).contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: const Text('All Categories'),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CustomTextFormField(
              controller: _searchController,
              labelText: 'Search',
              hintText: 'search categories...',
              icon: Icons.search,
            ),
          ),
          Expanded(
            child: isLoadingCategory
                ? const Center(child: CircularProgressIndicator())
                : filteredCategories.isEmpty
                    ? const Center(
                        child: Text(
                        "No categories found",
                        style: TextStyle(color: primaryColor, fontSize: 16),
                      ))
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: filteredCategories.length,
                          itemBuilder: (context, index) {
                            final category = filteredCategories[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => ProductsViewingScreen(
                                      categoryID: category.id,
                                      categoryName: category.name,
                                    ),
                                  ),
                                );
                              },
                              child: buildCategoryCard(
                                category.name,
                                category.imagePath,
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryCard(String title, String? imagePath) {
    return Card(
      color: cardColor2,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            imagePath != null && File(imagePath).existsSync()
                ? Image.file(
                    File(imagePath),
                    height: 155,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                : const Center(
                    child: Icon(
                      Icons.category,
                      size: 48,
                      color: primaryColor,
                    ),
                  ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
