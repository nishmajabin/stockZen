import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stockzen/Screens/brand/brand_list_screen.dart';
import 'package:stockzen/Screens/custbottomnavigation.dart';
import 'package:stockzen/Screens/inventory/widgets/custbottomsheet.dart';
import 'package:stockzen/Screens/inventory/widgets/custheadermain.dart';
import 'package:stockzen/Screens/inventory/widgets/custlist.dart';
import 'package:stockzen/Screens/category/category_list_screen.dart';
import 'package:stockzen/Screens/inventory/widgets/custrow.dart';
import 'package:stockzen/Screens/product/product_list_screen.dart';
import 'package:stockzen/functions/userdb.dart';
import 'package:stockzen/models/brand_model.dart';
import 'package:stockzen/models/category_model.dart';
import 'package:stockzen/models/product_model.dart';
import '../../constant.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<CategoryModel> categories = [];

  List<BrandModel> brands = [];

  List<ProductModel> products = [];

  String? pickedImage;
  String? productId;

  @override
  void initState() {
    super.initState();
    fetchUserImage();
  
  }



  Future<void> fetchUserImage() async {
    final user = await fetchUser();
    setState(() {
      pickedImage = user.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, primaryColor2, primaryColor],
            stops: [0.0, 4, 1.0],
          ),
        ),
        child: Column(
          children: [
            CustomHeader(
              pickedImage: pickedImage,
              fetchUserImage: fetchUserImage,
            ),
            const Divider(
              color: Color.fromARGB(255, 200, 200, 200),
            ),
            const SizedBox(height: 20),
            buildCustomRow(
                context: context,
                title: 'Categories',
                navigateTo: const CategoryListScreen()),
            const SizedBox(
              height: 25,
            ),
            CustomHorizontalListView(
              box: Hive.box<CategoryModel>('categories'),

            ),
            const SizedBox(
              height: 50,
            ),
            buildCustomRow(
                context: context,
                title: 'Brands',
                navigateTo: const BrandListScreen()),
            const SizedBox(
              height: 25,
            ),
  
            CustomHorizontalListView(
              box: Hive.box<BrandModel>('brands'),
            ),
            const SizedBox(
              height: 50,
            ),
            buildCustomRow(
                context: context,
                title: 'Products',
                navigateTo: const ProductListScreen()),
            const SizedBox(
              height: 25,
            ),
            CustomHorizontalListView(
              box: Hive.box<ProductModel>('products'),
              
 
            ),
          ],
        ),
      ),
      floatingActionButton:
          const CustomWidget().getFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}


  // void _fetchProducts() async {
  //   setState(() {
  //     _isLoadingProducts = true;
  //   });
  //   try {
  //     final fetchedProducts = _productDbfunction.getProduct();
  //     setState(() {
  //       products = fetchedProducts;
  //     });
  //   } catch (e) {
  //     print("Error fetching products: $e");
  //   } finally {
  //     setState(() {
  //       _isLoadingProducts = false;
  //     });
  //   }
  // }

  // void _fetchBrands() async {
  //   setState(() {
  //     _isLoadingBrands = true;
  //   });
  //   try {
  //     final fetchedBrands = _brandDbFunction.getBrands();
  //     setState(() {
  //       brands = fetchedBrands;
  //     });
  //   } catch (e) {
  //     print("Error fetching brands: $e");
  //   } finally {
  //     setState(() {
  //       _isLoadingBrands = false;
  //     });
  //   }
  // }

  // void _fetchCategories() async {
  //   setState(() {
  //     _isLoadingCategories = true;
  //   });

  //   try {
  //     final fetchedCategories = _categoryDbFunction.getCategories();
  //     setState(() {
  //       categories = fetchedCategories;
  //     });
  //   } catch (e) {
  //     print("Error fetching categories: $e");
  //   } finally {
  //     setState(() {
  //       _isLoadingCategories = false;
  //     });
  //   }
  // }


  // import 'package:stockzen/Screens/brand/products_brands.dart';
// import 'package:stockzen/Screens/category/products_viewing_categorised.dart';
// import 'package:stockzen/functions/brand_db.dart';
// import 'package:stockzen/functions/category_db.dart';
// import 'package:stockzen/functions/product_db.dart';

              // itemCount: categories.length,
              // isLoading: _isLoadingCategories,
              // emptyMessage: 'No categories yet. Click + to add categories.',
              // onNavigate: (context, index) {
              //   return ProductsViewingScreen(
              //     categoryID: categories[index].id,
              //     categoryName: categories[index].name,
              //   );
              // },
              // childBuilder: (context, index) {
              //   return CustomCard(
              //     index: index,
              //     product: categories[index],
              //     model: CategoryModel,
              //     title: categories[index].name,
              //     imagePath: categories[index].imagePath,
              //   );
              // },
                        // CustomHorizontalListView(
            // itemCount: brands.length,
            // isLoading: _isLoadingBrands,
            // emptyMessage: 'No brands yet. Click + to add brands.',
            // onNavigate: (context, index) {
            //   return ProductsViewingBrandScreen(
            //     brandID: brands[index].id,
            //     brandName: brands[index].name,
            //   );
            // },
            // childBuilder: (context, index) {
            //   return CustomCard(
            //     index: index,
            //     product: brands[index],
            //     model: BrandModel,
            //     title: brands[index].name,
            //     imagePath: brands[index].imagePath,
            //   );
            // },
            // ),
             // itemCount: products.length,
              // isLoading: _isLoadingProducts,
              // emptyMessage: 'No products yet. Click + to add products.',
              // onNavigate: (context, index) {
              //   return ProductDetailsScreen(product: products[index]);
              // },
              // childBuilder: (context, index) {
              //   return CustomCard(
              //     index: index,
              //     product: products[index],
              //     model: ProductModel,
              //     title: products[index].productName,
              //     imagePath: products[index].productImagePath,
              //   );
              // },
                // final CategoryDB _categoryDbFunction = CategoryDB();
  // bool _isLoadingCategories = true;
    // final BrandDb _brandDbFunction = BrandDb();
  // bool _isLoadingBrands = true;
    // final ProductDb _productDbfunction = ProductDb();
  // bool _isLoadingProducts = true;
    // _fetchCategories();
    // _fetchBrands();
    // _fetchProducts();