import 'package:hive/hive.dart';
import '../models/category_model.dart';

class CategoryDB {
  static final CategoryDB _instance = CategoryDB._internal();
  factory CategoryDB() => _instance;
  CategoryDB._internal();

  static const String boxName = 'categories';

  Future<void> addCategory(CategoryModel category) async {
    final categoryBox = Hive.box<CategoryModel>(boxName);
    await categoryBox.add(category);
  }

  List<CategoryModel> getCategories() {
    final categoryBox = Hive.box<CategoryModel>(boxName);
    return categoryBox.values.toList();
  }

  Future<void> deleteCategory(int key) async {
    final categoryBox = Hive.box<CategoryModel>(boxName);
    await categoryBox.delete(key);
  }

  Future<void> updateCategory( CategoryModel updatedCategory) async {
    final categoryBox = Hive.box<CategoryModel>(boxName);
    final index = categoryBox.values 
        .toList()
        .indexWhere((category) => category.id == updatedCategory.id);
    await categoryBox.putAt(index, updatedCategory);
  }
}
