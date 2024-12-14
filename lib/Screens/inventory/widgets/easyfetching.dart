import 'package:stockzen/functions/brand_db.dart';
import 'package:stockzen/functions/category_db.dart';
import 'package:stockzen/functions/product_db.dart';

class DataService {
  final _productDbFunction = ProductDb();
  final _brandDbFunction = BrandDb();
  final _categoryDbFunction = CategoryDB();

  Future<Map<String, List<dynamic>>> fetchAllData() async {
    try {
      final products = await _productDbFunction.getProduct();
      final brands = await _brandDbFunction.getBrands();
      final categories = await _categoryDbFunction.getCategories();

      return {
        'products': products,
        'brands': brands,
        'categories': categories,
      };
    } catch (e) {
      print("Error fetching data: $e");
      return {}; 
    }
  }
}
