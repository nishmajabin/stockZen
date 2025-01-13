import 'dart:developer';
import 'package:hive/hive.dart';

import 'package:stockzen/models/product_model.dart';
import 'package:stockzen/models/sales_model.dart';

// Function to add a sale
Future<void> addSale(SalesModel sale) async {
  final salesBox = await Hive.openBox<SalesModel>('salesBox');

  //Reduce stock for each product in the sale

  await salesBox.add(sale);
  log('Sale added successfully');
}

// Function to get all sales
Future<List<SalesModel>> getAllSales() async {
  final salesBox = await Hive.openBox<SalesModel>('salesBox');
  return salesBox.values.toList();
}

// Function to delete a sale
Future<void> deleteSale(SalesModel sale) async {
  final salesBox = await Hive.openBox<SalesModel>('salesBox');
  final index =
      salesBox.values.toList().indexWhere((element) => element.id == sale.id);

  if (index != -1) {
    await salesBox.deleteAt(index);
    log('Sale deleted successfully');
  } else {
    log('Sale not found');
  }
}

Future<String> getProductNameById(String productId) async {
  final productBox = await Hive.openBox<ProductModel>(
      'products'); // Ensure you're opening the correct box
  final index =
      productBox.values.toList().indexWhere((value) => value.id == productId);
  final product = productBox.getAt(index);
  log('tthis funcion called >>>>>>>>>>>>>');
  return product?.name ??
      ''; // Change `name` to the appropriate field in your ProductModel
}
