import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:stockzen/Screens/sales/sales_add.dart';
import 'package:stockzen/models/product_model.dart';

class ProductDb {
  static final ProductDb _instance = ProductDb._internal();
  factory ProductDb() => _instance;
  ProductDb._internal();

  static const String productsBoxName = 'products';

  Future<void> addProduct(ProductModel product) async {
    final productBox = Hive.box<ProductModel>(productsBoxName);
    await productBox.add(product);
  }

  List<ProductModel> getProduct() {
    final productBox = Hive.box<ProductModel>(productsBoxName);
    return productBox.values.toList();
  }

  Future<ProductModel> getProductById(String id) async {
    final productBox = Hive.box<ProductModel>(productsBoxName);
    final product = productBox.values.firstWhere((product) => product.id == id);
    return product;
  }

  Future<void> deleteProduct(String id) async {
    final productBox = Hive.box<ProductModel>(productsBoxName);
    final index =
        productBox.values.toList().indexWhere((product) => product.id == id);
    await productBox.deleteAt(index);
  }

  Future<void> updateProduct(String key, ProductModel updatedProduct) async {
    final productBox = Hive.box<ProductModel>(productsBoxName);
    final index =
        productBox.values.toList().indexWhere((value) => value.id == key);

    await productBox.putAt(index, updatedProduct);
  }

  Future<List<ProductModel>> getProductsByBrands(String brandId) async {
    List<ProductModel> productsB = [];
    final productBox = Hive.box<ProductModel>(productsBoxName);
    for (var value in productBox.values) {
      if (value.brand == brandId) {
        productsB.add(value);
      }
    }
    return productsB;
  }

  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    List<ProductModel> productsC = [];
    final productBox = Hive.box<ProductModel>(productsBoxName);
    for (var value in productBox.values) {
      if (value.category == categoryId) {
        productsC.add(value);
      }
    }
    return productsC;
  }
  // Future<void> reduceProductQuantity(String productId, int quantitySold) async {
  //   final box = await Hive.openBox<ProductModel>('products');
  //   int newCount = quantitySold;
  //   final index =
  //       box.values.toList().indexWhere((value) => productId == value.id);
  //   final product = box.getAt(index);
  //   if (product != null) {
  //     final newProduct = product;
  //     newProduct.quantity = newCount;
  //     log('count:${newProduct.quantity},parameter: $newCount');
  //     box.putAt(index, newProduct);
  //   }
  // }

  Future<void> updateCountOfProduct(
      List<SelectedProduct> selectedProducts) async {
    final box = await Hive.openBox<ProductModel>('products');
    try {
      for (var sp in selectedProducts) {
        final product = sp.product;
        log('${product.quantity} >>>> this is default value');

        // Calculate the new quantity
        final newQuantity = product.quantity - sp.quantity;
        log('${newQuantity} >>>> this is new value');

        // Find the product in the box by ID
        final index =
            box.values.toList().indexWhere((value) => product.id == value.id);
        if (index != -1) {
          final updatedProduct = box.getAt(index);
          if (updatedProduct != null) {
            updatedProduct.quantity = newQuantity;
            log('Updating product quantity: ${updatedProduct.quantity}');

            // Update the product in the box
            await box.putAt(index, updatedProduct);
          }
        } else {
          log('Product with ID ${product.id} not found in the box');
        }
      }
    } catch (e) {
      log('Error updating product count: $e');
    } 
  }
}
