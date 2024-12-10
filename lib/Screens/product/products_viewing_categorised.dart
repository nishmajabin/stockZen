import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stockzen/Screens/product/product_details_screen.dart';
import 'package:stockzen/functions/product_db.dart';
import 'package:stockzen/models/product_model.dart';

import '../../constant.dart';

class ProductsViewingScreen extends StatefulWidget {
  final String categoryID;
  final String categoryName;
  ProductsViewingScreen(
      {super.key, required this.categoryID, required this.categoryName});

  @override
  State<ProductsViewingScreen> createState() => _ProductsViewingScreenState();
}

class _ProductsViewingScreenState extends State<ProductsViewingScreen> {
  List<ProductModel> productsC = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategoryDetails();
  }

  void _fetchCategoryDetails() async {
    try {
      final values = await ProductDb().getProductsByCategory(widget.categoryID);
      setState(() {
        productsC = values;
        isLoading = false;
      });
    } catch (e) {
      log("Error fetching products: $e");
      setState(() {
        isLoading = false;
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
            title: Text("Products in ${widget.categoryName}"),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : productsC.isEmpty
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
                    itemCount: productsC.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => ProductDetailsScreen(
                                      product: productsC[index])));
                        },
                        child: _buildCategoryCard(
                          productsC[index].productName,
                          productsC[index].price as String,
                          productsC[index].productImagePath,
                        ),
                      );
                    },
                  ),
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
            SizedBox(
              height: 10,
            ),
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Price: ₹$price.00',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 24, 101, 26)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
