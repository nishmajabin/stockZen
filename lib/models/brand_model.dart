import 'package:hive/hive.dart';
part 'brand_model.g.dart';

@HiveType(typeId: 2)
class BrandModel {

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String imagePath;

  BrandModel({required this.id, required this.name, required this.imagePath});
}
