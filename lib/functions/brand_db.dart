import 'package:hive/hive.dart';
import 'package:stockzen/models/brand_model.dart';

class BrandDb {
  static final BrandDb _instance = BrandDb._internal();
  factory BrandDb() => _instance;
  BrandDb._internal();

  static const String brandBoxName = 'brands';

  Future<void> addBrand(BrandModel brand) async {
    final brandBox = Hive.box<BrandModel>(brandBoxName);
    await brandBox.add(brand);
  }

  List<BrandModel> getBrands() {
    final brandBox = Hive.box<BrandModel>(brandBoxName);
    return brandBox.values.toList();
  }

  Future<void> deleteBrand(int key) async {
    final brandBox = Hive.box<BrandModel>(brandBoxName);
    await brandBox.delete(key);
  }

  Future<void> updateBrand(BrandModel updatedBrand) async {
    final brandBox = Hive.box<BrandModel>(brandBoxName);
    final index = brandBox.values
        .toList()
        .indexWhere((brand) => brand.id == updatedBrand.id);
    await brandBox.putAt(index, updatedBrand);
  }
}
