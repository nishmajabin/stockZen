import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stockzen/Screens/product/product_details_screen.dart';
import 'package:stockzen/functions/product_db.dart';
import 'package:stockzen/models/product_model.dart';

import '../../constant.dart';

class ProductsViewingBrandScreen extends StatefulWidget {
  final String brandID;
  final String brandName;
  ProductsViewingBrandScreen(
      {super.key, required this.brandID, required this.brandName});

  @override
  State<ProductsViewingBrandScreen> createState() =>
      _ProductsViewingBrandScreenState();
}

class _ProductsViewingBrandScreenState
    extends State<ProductsViewingBrandScreen> {
  List<ProductModel> productsB = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBrandDetails();
  }

  void _fetchBrandDetails() async {
    try {
      final values = await ProductDb().getProductsByBrands(widget.brandID);
      setState(() {
        productsB = values; // Assuming values is a List<ProductModel>
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
            title: Text("Products by ${widget.brandName}"),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : productsB.isEmpty
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
                        itemCount: productsB.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => ProductDetailsScreen(
                                          product: productsB[index])));
                            },
                            child: _buildCategoryCard(
                              productsB[index].productName,
                              productsB[index].price as String,
                              productsB[index].productImagePath,
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
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    // color: Colors.white
                  ),
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
                    color: Colors.green),
              ),
            )
          ],
        ),
      ),
    );
  }
}
