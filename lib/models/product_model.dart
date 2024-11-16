import 'package:hive_flutter/hive_flutter.dart';
part 'product_model.g.dart';

@HiveType(typeId: 4)
class ProductModel {
  @HiveField(0)
  String? productName;
  @HiveField(1)
  String? category;
  @HiveField(2)
  String? brand;
  @HiveField(3)
  String? productImagePath;
  @HiveField(4)
  String? color;
  @HiveField(5)
  String? quantity;
  @HiveField(6)
  String? price;
  @HiveField(7)
  String? description;
}
