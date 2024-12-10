// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';
import 'package:stockzen/models/product_model.dart';
part 'sales_model.g.dart';
@HiveType(typeId: 4)
class SalesModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String date;

  @HiveField(2)
  String customerName;

  @HiveField(3)
  String customerNumber;

  @HiveField(4)
  List<ProductModel> products;

  @HiveField(5)
  final double? totalAmount;

  @HiveField(6)
  int saleQuantity;

  SalesModel({
    required this.id,
    required this.date,
    required this.customerName,
    required this.customerNumber,
    required this.products,
    required this.totalAmount,
    required this.saleQuantity
  });
}