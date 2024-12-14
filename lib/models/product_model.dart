import 'package:hive_flutter/hive_flutter.dart';
part 'product_model.g.dart';

@HiveType(typeId: 3)
class ProductModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String category;

  @HiveField(3)
  String brand;

  @HiveField(4)
  String imagePath;

  @HiveField(5)
  String color;

  @HiveField(6)
  int quantity;

  @HiveField(7)
  double price;

  @HiveField(8)
  String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.brand,
    required this.imagePath,
    required this.color,
    required this.quantity,
    required this.price,
    required this.description,
  });
}
