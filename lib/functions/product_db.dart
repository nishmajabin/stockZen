import 'package:hive_flutter/hive_flutter.dart';
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
}
