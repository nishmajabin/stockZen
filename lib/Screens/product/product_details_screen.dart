import 'dart:io';
import 'dart:math';
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
  late ProductModel _product;
  String? categoryName;
  String? brandName;
  @override
  void initState() {
    super.initState();
    _product = widget.product;
    getProduct();
    _loadBrands();
    _loadCategories();
  }

  void _loadCategories() async {
    final categories = CategoryDB().getCategories();

    final cat =
        categories.firstWhere((value) => value.id == widget.product.category);
    categoryName = cat.name;

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
    _product = await ProductDb().getProductById(widget.product.id);
  }

  void _navigateToEditPage() async {
    final updatedProduct = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => EditProductScreen(
                  product: _product,
                  productName: _product.productName,
                  brand: _product.brand,
                  category: _product.category,
                  image: _product.productImagePath,
                  color: _product.color,
                  quantity: _product.quantity,
                  price: _product.price,
                  description: _product.description,
                  productKey: _product.id,
                )));

    if (updatedProduct != null) {
      setState(() {
        _product = updatedProduct;
      });
    }
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
      expandedHeight: 350.0,
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
        _product.productImagePath != null
            ? Image.file(File(_product.productImagePath), fit: BoxFit.cover)
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
            _product.productName,
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
            '₹${_product.price}',
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
            _buildDetailRow('Brand', brandName ?? _product.brand),
            _buildDetailRow('Category', categoryName ?? _product.category),
            _buildDetailRow('Quantity', _product.quantity.toString()),
            _buildDetailRow('Color', _product.color),
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
            _product.description ?? 'No description available.',
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
