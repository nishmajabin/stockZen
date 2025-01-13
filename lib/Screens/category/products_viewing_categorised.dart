import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stockzen/screens/custom_appbar.dart';
import 'package:stockzen/screens/product/product_details_screen.dart';
import 'package:stockzen/screens/profile/edit_profile/widgets/text_form.dart';
import 'package:stockzen/functions/product_db.dart';
import 'package:stockzen/models/product_model.dart';

import '../../constant.dart';

class ProductsViewingScreen extends StatefulWidget {
  final String categoryID;
  final String categoryName;
  const ProductsViewingScreen({
    super.key, 
    required this.categoryID, 
    required this.categoryName
  });

  @override
  State<ProductsViewingScreen> createState() => _ProductsViewingScreenState();
}

class _ProductsViewingScreenState extends State<ProductsViewingScreen> {
  // Added search controller and filtered products list
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> productsC = [];
  List<ProductModel> filteredProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategoryDetails();
    // Add listener for search functionality
    _searchController.addListener(() {
      _filterProducts(_searchController.text);
    });
  }

  // Added dispose method to clean up controller
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchCategoryDetails() async {
    try {
      final values = await ProductDb().getProductsByCategory(widget.categoryID);
      setState(() {
        productsC = values;
        filteredProducts = List.from(productsC); // Initialize filtered list
        isLoading = false;
      });
    } catch (e) {
      log("Error fetching products: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Added filter function
  void _filterProducts(String query) {
    setState(() {
      filteredProducts = productsC
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(title: "Products in ${widget.categoryName}"),
      body: Column(
        children: [
          // Added search field
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CustomTextFormField(
              controller: _searchController,
              labelText: 'Search',
              hintText: 'search products...',
              icon: Icons.search,
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredProducts.isEmpty
                    ? const Center(child: Text("No products available."))
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: filteredProducts.length, // Updated to use filtered list
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => ProductDetailsScreen(
                                            product: filteredProducts[index]))); // Updated to use filtered list
                              },
                              child: _buildCategoryCard(
                                filteredProducts[index].name,
                                filteredProducts[index].price.toString(),
                                filteredProducts[index].imagePath,
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

  Widget _buildCategoryCard(String title, String price, String imagepath) {
    return Card(
      color: const Color.fromARGB(200, 182, 211, 233),
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
              height: 150,
              width: 200,
              fit: BoxFit.fill,
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
                padding: const EdgeInsets.only(bottom: 25),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Price: ₹$price',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: priceColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}