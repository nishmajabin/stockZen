import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stockzen/Screens/product/edit_product_screen.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/brand_db.dart';
import 'package:stockzen/functions/category_db.dart';
import 'package:stockzen/functions/product_db.dart';
import 'package:stockzen/models/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsScreen> {
  late ProductModel product;
  String? categoryName;
  String? brandName;
  @override
  void initState() {
    super.initState();
    product = widget.product;
    getProduct();
    _loadBrands();
    _loadCategories();
  }

  void _loadCategories() async {
    final categories = CategoryDB().getCategories();

    final category =
        categories.firstWhere((value) => value.id == widget.product.category);
    categoryName = category.name;

    setState(() {});
  }

  void _loadBrands() async {
    final brands = BrandDb().getBrands();
    final currentBrand =
        brands.firstWhere((brand) => brand.id == widget.product.brand);

    brandName = currentBrand.name;

    setState(() {});
  }

  Future<void> getProduct() async {
    product = await ProductDb().getProductById(widget.product.id);
  }

  void _navigateToEditPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => EditProductScreen(
                  product: product,
                  productName: product.name,
                  brand: product.brand,
                  category: product.category,
                  image: product.imagePath,
                  color: product.color,
                  quantity: product.quantity,
                  price: product.price,
                  description: product.description,
                  productKey: product.id,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: _buildProductDetails(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToEditPage,
        child: Icon(Icons.edit, color: Colors.white),
        backgroundColor: primaryColor,
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 430.0,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: _buildProductImage(),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Container(
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ignore: unnecessary_null_comparison
        product.imagePath != null
            ? Image.file(File(product.imagePath), fit: BoxFit.cover)
            : Container(color: Colors.grey[200]),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 20,
          child: Text(
            product.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.black, blurRadius: 2)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPriceTag(),
          _buildDetailCard(),
          _buildDescription(),
        ],
      ),
    );
  }

  Widget _buildPriceTag() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '₹${product.price}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'In Stock',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailRow('Brand', brandName ?? product.brand),
            _buildDetailRow('Category', categoryName ?? product.category),
            _buildDetailRow('Quantity', product.quantity.toString()),
            _buildDetailRow('Color', product.color),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Text(
            product.description,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
