import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stockzen/Screens/add_brand_screen.dart';
import 'package:stockzen/Screens/add_category_screen.dart';
import 'package:stockzen/Screens/add_product_screen.dart';
import 'package:stockzen/Screens/brand_list_screen.dart';
import 'package:stockzen/Screens/category_list_screen.dart';
import 'package:stockzen/functions/brand_db.dart';
import 'package:stockzen/functions/category_db.dart';
import 'package:stockzen/models/brand_model.dart';
import 'package:stockzen/models/category_model.dart';
import 'package:stockzen/Screens/profile_screen.dart';
import '../constant.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  int _selectedIndex = 0;
  List<CategoryModel> categories = [];
  final CategoryDB _categoryDbFunction = CategoryDB();
  bool _isLoadingCategories = true;
  List<BrandModel> brands = [];
  final BrandDb _brandDbFunction = BrandDb();
  bool _isLoadingBrands = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
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
      print("Error fetching brands: $e");
    } finally {
      setState(() {
        _isLoadingBrands = false;
      });
    }
  }

  void _fetchCategories() async {
    setState(() {
      _isLoadingCategories = true;
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
        _isLoadingCategories = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAddBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.category, color: primaryColor),
                title: const Text(
                  'Add Category',
                  style: TextStyle(color: primaryColor),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddCategoryScreen(),
                    ),
                  );
                  if (value != null) {
                    setState(() {
                      _fetchCategories();
                    });
                  }
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.branding_watermark, color: primaryColor),
                title: const Text(
                  'Add Brand',
                  style: TextStyle(color: primaryColor),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddBrandScreen(),
                    ),
                  );
                  if (value != null) {
                    setState(() {
                      _fetchBrands();
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_box, color: primaryColor),
                title: const Text(
                  'Add Product',
                  style: TextStyle(color: primaryColor),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => AddProductScreen()));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, primaryColor2, primaryColor],
            stops: [0.0, 4, 1.0],
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 126,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'stockZen',
                        style: TextStyle(
                          fontFamily: 'Rakkas',
                          color: Colors.white,
                          fontSize: 48,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.person,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CategoryListScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'More...',
                      style: TextStyle(color: secondColor),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: SizedBox(
                width: double.infinity,
                height: 140,
                child: _isLoadingCategories
                    ? const Center(child: CircularProgressIndicator())
                    : categories.isEmpty
                        ? const Center(
                            child: Text(
                              'No categories yet. Click + to add categories.',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: _buildCategoryCard(
                                  categories[index].name,
                                  categories[index].imagePath,
                                ),
                              );
                            },
                          ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Brands',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BrandListScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'More...',
                      style: TextStyle(color: secondColor),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: SizedBox(
                width: double.infinity,
                height: 140,
                child: _isLoadingBrands
                    ? const Center(child: CircularProgressIndicator())
                    : brands.isEmpty
                        ? const Center(
                            child: Text(
                              'No brands yet. Click + to add brands.',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: brands.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: _buildCategoryCard(
                                  brands[index].name,
                                  brands[index].imagePath,
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBottomSheet,
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: primaryColor,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_down),
            label: 'Stock Out',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imagePath) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
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
              File(imagePath),
              height: 140,
              width: 140,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: primaryColor.withOpacity(0.2),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.category,
                    size: 48,
                    color: primaryColor,
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
                  Colors.black.withOpacity(1)
                ],
              )),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
