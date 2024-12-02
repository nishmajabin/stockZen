import 'package:flutter/material.dart';
import 'package:stockzen/Screens/product/product_details_screen.dart';
import 'package:stockzen/models/product_model.dart';

Future<void> navigateToEditProduct(
    ProductModel product, BuildContext context) async {
  // Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (ctx) => EditProductScreen(
  //             productKey: product.id,
  //             productName: product.productName,
  //             brand: product.brand,
  //             category: product.category,
  //             image: product.productImagePath,
  //             color: product.color,
  //             quantity: product.quantity,
  //             price: product.price,
  //             description: product.description)));
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (ctx) => ProductDetailsScreen(product: product)));
}
