import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stockzen/screens/brand/brand_list_screen.dart';
import 'package:stockzen/screens/inventory/widgets/custom_bottom_sheet.dart';
import 'package:stockzen/screens/inventory/widgets/custom_header_main.dart';
import 'package:stockzen/screens/inventory/widgets/custom_list.dart';
import 'package:stockzen/screens/category/category_list_screen.dart';
import 'package:stockzen/screens/inventory/widgets/custom_row.dart';
import 'package:stockzen/screens/inventory/widgets/custom_vertical_list.dart';
import 'package:stockzen/screens/product/product_list_screen.dart';
import 'package:stockzen/functions/user_db.dart';
import 'package:stockzen/models/brand_model.dart';
import 'package:stockzen/models/category_model.dart';
import 'package:stockzen/models/product_model.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<CategoryModel> categories = [];
  List<BrandModel> brands = [];
  List<ProductModel> products = [];
  String? pickedImage;
  String? productId;

  @override
  void initState() {
    super.initState();
    fetchUserImage();
  }

  Future<void> fetchUserImage() async {
    final user = await fetchUser();
    setState(() {
      pickedImage = user.image;
    });
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
            colors: [
              Color.fromARGB(255, 8, 33, 51),
              Color.fromARGB(241, 13, 45, 66),
              Color.fromARGB(255, 7, 25, 37)
            ],
            stops: [0.0, 4, 1.0],
          ),
        ),
        child: Column(
          children: [
            // Fixed header section
            CustomHeader(
              pickedImage: pickedImage,
              fetchUserImage: fetchUserImage,
            ),
            SizedBox(
              height: 20,
            ),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    buildCustomRow(
                        context: context,
                        title: 'Categories',
                        navigateTo: const CategoryListScreen()),
                    const SizedBox(height: 25),
                    CustomHorizontalListView(
                      box: Hive.box<CategoryModel>('categories'),
                    ),
                    const SizedBox(height: 25),
                    const Divider(
                      color: Color.fromARGB(255, 200, 200, 200),
                      height: 0.8,
                      indent: 12,
                      endIndent: 12,
                    ),
                    const SizedBox(height: 25),
                    buildCustomRow(
                        context: context,
                        title: 'Brands',
                        navigateTo: const BrandListScreen()),
                    const SizedBox(height: 25),
                    CustomHorizontalListView(
                      box: Hive.box<BrandModel>('brands'),
                    ),
                    const SizedBox(height: 25),
                    const Divider(
                      color: Color.fromARGB(255, 200, 200, 200),
                      height: 0.8,
                      indent: 12,
                      endIndent: 12,
                    ),
                    const SizedBox(height: 25),
                    buildCustomRow(
                        context: context,
                        title: 'Products',
                        navigateTo: const ProductListScreen()),
                    CustomVerticalListView(
                      box: Hive.box<ProductModel>('products'),
                    ),
                    const SizedBox(height: 80), // Bottom padding for FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          const CustomWidget().getFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
