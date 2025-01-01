import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stockzen/Screens/brand/products_brands.dart';
import 'package:stockzen/Screens/profile/edit_profile/widgets/text_form.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/brand_db.dart';
import 'package:stockzen/models/brand_model.dart';

class BrandListScreen extends StatefulWidget {
  const BrandListScreen({super.key});

  @override
  State<BrandListScreen> createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<BrandModel> brands = [];
  final BrandDb _brandDbFunction = BrandDb();
  bool _isLoadingBrands = true;
  List<BrandModel> filteredBrands = [];

  @override
  void initState() {
    super.initState();
    _fetchBrands();
    _searchController.addListener(() {
      _filterBrands(_searchController.text);
    });
  }

  void _fetchBrands() async {
    setState(() {
      _isLoadingBrands = true;
    });
    try {
      final fetchedBrands = await _brandDbFunction.getBrands();
      setState(() {
        brands = fetchedBrands;
        filteredBrands = List.from(brands);
      });
    } catch (e) {
      print("Error fetching brands: $e");
    } finally {
      setState(() {
        _isLoadingBrands = false;
      });
    }
  }

  void _filterBrands(String query) {
    setState(() {
      filteredBrands = brands
          .where((brand) =>
              (brand.name.toLowerCase()).contains(query.toLowerCase()))
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
            'All Brands',
          ),
          backgroundColor:primaryColor  ,
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
              hintText: 'search brands...',
              icon: Icons.search,
            ),
          ),
          Expanded(
            child: _isLoadingBrands
                ? const Center(child: CircularProgressIndicator())
                : filteredBrands.isEmpty
                    ? const Center(
                        child: Text(
                          'No Brands added yet!',
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
                          itemCount: filteredBrands.length,
                          itemBuilder: (context, index) {
                            final brand = filteredBrands[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            ProductsViewingBrandScreen(
                                                brandID: brand.id,
                                                brandName: brand.name)));
                              },
                              child: buildBrandCard(
                                brand.name,
                                brand.imagePath,
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

  Widget buildBrandCard(String title, String imagepath) {
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
            Image.file(
              File(imagepath),
              height: 155,
              width: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.category,
                  size: 48,
                  color: primaryColor,
                );
              },
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
