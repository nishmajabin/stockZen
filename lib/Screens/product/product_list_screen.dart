import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stockzen/Screens/product/product_details_screen.dart';
import 'package:stockzen/Screens/profile/edit_profile/widgets/text_form.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/product_db.dart';
import 'package:stockzen/models/product_model.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> products = [];
  final ProductDb _productDbFunction = ProductDb();
  bool _isLoadingProducts = true;
  List<ProductModel> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _searchController.addListener(() {
      _filterProducts(_searchController.text);
    });
  }

  void _fetchProducts() async {
    setState(() {
      _isLoadingProducts = true;
    });
    try {
      final fetchedProducts = _productDbFunction.getProduct();
      setState(() {
        products = fetchedProducts;
        filteredProducts = List.from(products);
      });
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      setState(() {
        _isLoadingProducts = false;
      });
    }
  }

  void _filterProducts(String query) {
    setState(() {
      filteredProducts = products
          .where((product) =>
              (product.name.toLowerCase()).contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: const Text(
            'All Products',
          ),
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
              hintText: 'search products...',
              icon: Icons.search,
            ),
          ),
          Expanded(
            child: _isLoadingProducts
                ? const Center(child: CircularProgressIndicator())
                : filteredProducts.isEmpty
                    ? const Center(
                        child: Text(
                          'No Products added yet!',
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
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => ProductDetailsScreen(
                                            product: product)));
                              },
                              child: buildProductCard(product.name,
                                  product.price.toString(), product.imagePath),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget buildProductCard(String title, String price, String imagepath) {
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
            Align(
                alignment: Alignment.topRight,
                child: IconButton(onPressed: () {}, icon: Icon(Icons.delete),)),
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
