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

  Future<void> deleteProduct(int key) async {
    final productBox = Hive.box<ProductModel>(productsBoxName);
    await productBox.delete(key);
  }

  Future<void> updateProduct(int key, ProductModel updatedProduct) async {
    final productBox = Hive.box<ProductModel>(productsBoxName);
    await productBox.put(key, updatedProduct);
  }
}
