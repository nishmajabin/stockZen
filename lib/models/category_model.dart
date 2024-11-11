// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';
part 'category_model.g.dart';


@HiveType(typeId: 1)
class CategoryModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String imagePath;

  CategoryModel({this.id, required this.name, required this.imagePath});
}
