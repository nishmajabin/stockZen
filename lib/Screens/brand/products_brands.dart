import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stockzen/Screens/product/product_details_screen.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/product_db.dart';
import 'package:stockzen/models/product_model.dart';

class ProductsViewingBrandScreen extends StatefulWidget {
  final String brandID;
  final String brandName;
  const ProductsViewingBrandScreen(
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
        productsB = values; 
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
        child: AppBar(
          title: Text("Products by ${widget.brandName}"),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
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
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
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
                        child: buildBrandCard(
                          productsB[index].name,
                          productsB[index].price.toString(),
                          productsB[index].imagePath,
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget buildBrandCard(String title, String price, String imagepath) {
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
              width: double.infinity,
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
                    fontSize: 17.5,
                    fontWeight: FontWeight.bold,
                  ),
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
