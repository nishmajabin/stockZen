import 'package:flutter/material.dart';
import 'package:stockzen/models/brand_model.dart';
import 'package:stockzen/models/category_model.dart';
import 'package:stockzen/models/sales_model.dart';
import 'package:stockzen/models/usermodel.dart';
import 'package:stockzen/models/product_model.dart';
import 'package:stockzen/Screens/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

const userLogged = 'userLogged';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('user_db');
  Hive.registerAdapter(CategoryModelAdapter());
  await Hive.openBox<CategoryModel>('categories');
  Hive.registerAdapter(BrandModelAdapter());
  await Hive.openBox<BrandModel>('brands');
  Hive.registerAdapter(ProductModelAdapter());
  await Hive.openBox<ProductModel>('products');
  Hive.registerAdapter(SalesModelAdapter());
  await Hive.openBox<SalesModel>('sales');

  runApp(const StockApp());
}

class StockApp extends StatelessWidget {
  const StockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
