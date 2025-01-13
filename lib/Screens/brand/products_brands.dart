import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stockzen/screens/custom_appbar.dart';
import 'package:stockzen/screens/product/product_details_screen.dart';
import 'package:stockzen/screens/profile/edit_profile/widgets/text_form.dart';
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
  // Adding search functionality state variables
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> productsB = [];
  List<ProductModel> filteredProducts = []; // New list for filtered results
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBrandDetails();
    // Adding search listener
    _searchController.addListener(() {
      _filterProducts(_searchController.text);
    });
  }

  @override
  void dispose() {
    // Clean up controller when widget is disposed
    _searchController.dispose();
    super.dispose();
  }

  void _fetchBrandDetails() async {
    try {
      final values = await ProductDb().getProductsByBrands(widget.brandID);
      setState(() {
        productsB = values;
        filteredProducts =
            List.from(productsB); // Initialize filtered list with all products
        isLoading = false;
      });
    } catch (e) {
      log("Error fetching products: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // New method to filter products based on search query
  void _filterProducts(String query) {
    setState(() {
      filteredProducts = productsB
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Products by ${widget.brandName}"),
      body: Column(
        children: [
          // Adding search field
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CustomTextFormField(
              controller: _searchController,
              labelText: 'Search',
              hintText: 'search products...',
              icon: Icons.search,
              height: 5,
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
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount:
                              filteredProducts.length, // Using filtered list
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => ProductDetailsScreen(
                                            product: filteredProducts[
                                                index]))); // Using filtered list
                              },
                              child: buildBrandCard(
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
