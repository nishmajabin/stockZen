import 'package:hive/hive.dart';
part 'brand_model.g.dart';

@HiveType(typeId: 2)
class BrandModel {

  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String imagePath;

  BrandModel({this.id, required this.name, required this.imagePath});
}
