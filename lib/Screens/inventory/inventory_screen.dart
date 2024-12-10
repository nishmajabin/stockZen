import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stockzen/Screens/brand/add_brand_screen.dart';
import 'package:stockzen/Screens/brand/brand_list_screen.dart';
import 'package:stockzen/Screens/brand/edit_brand_screen.dart';
import 'package:stockzen/Screens/category/add_category_screen.dart';
import 'package:stockzen/Screens/category/edit_category_screen.dart';
import 'package:stockzen/Screens/product/add_product_screen.dart';
import 'package:stockzen/Screens/category/category_list_screen.dart';
import 'package:stockzen/Screens/inventory/widgets/custrow.dart';
import 'package:stockzen/Screens/product/edit_product_screen.dart';
import 'package:stockzen/Screens/product/product_details_screen.dart';
import 'package:stockzen/Screens/product/product_list_screen.dart';
import 'package:stockzen/Screens/product/products_brands.dart';
import 'package:stockzen/Screens/product/products_viewing_categorised.dart';
import 'package:stockzen/Screens/sales/sales_billing.dart';
import 'package:stockzen/functions/brand_db.dart';
import 'package:stockzen/functions/category_db.dart';
import 'package:stockzen/functions/product_db.dart';
import 'package:stockzen/functions/userdb.dart';
import 'package:stockzen/models/brand_model.dart';
import 'package:stockzen/models/category_model.dart';
import 'package:stockzen/Screens/profile/profile/profile_screen.dart';
import 'package:stockzen/models/product_model.dart';
import '../../constant.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  int _selectedIndex = 0;
  List<CategoryModel> categories = [];
  final CategoryDB _categoryDbFunction = CategoryDB();
  bool _isLoadingCategories = true;
  List<BrandModel> brands = [];
  final BrandDb _brandDbFunction = BrandDb();
  bool _isLoadingBrands = true;
  List<ProductModel> products = [];
  final ProductDb _productDbfunction = ProductDb();
  bool _isLoadingProducts = true;
  // late ProductModel _product;
  String? pickedImage;
  String? productId;

  @override
  void initState() {
    super.initState();
    fetchUserImage();
    _fetchCategories();
    _fetchBrands();
    _fetchProducts();
  }

  void _fetchProducts() async {
    setState(() {
      _isLoadingProducts = true;
    });
    try {
      final fetchedProducts = _productDbfunction.getProduct();
      setState(() {
        products = fetchedProducts;
      });
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      setState(() {
        _isLoadingProducts = false;
      });
    }
  }

  void _fetchBrands() async {
    setState(() {
      _isLoadingBrands = true;
    });
    try {
      final fetchedBrands = _brandDbFunction.getBrands();
      setState(() {
        brands = fetchedBrands;
      });
    } catch (e) {
      print("Error fetching brands: $e");
    } finally {
      setState(() {
        _isLoadingBrands = false;
      });
    }
  }

  void _fetchCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });

    try {
      final fetchedCategories = _categoryDbFunction.getCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  Future<void> fetchUserImage() async {
    final user = await fetchUser();
    setState(() {
      pickedImage = user.image;
    });
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InventoryScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SalesPage()),
        );
        break;
    }
  }

  void showAddBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.category, color: primaryColor),
                title: const Text(
                  'Add Category',
                  style: TextStyle(color: primaryColor),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddCategoryScreen(),
                    ),
                  );
                  if (value != null) {
                    setState(() {
                      _fetchCategories();
                    });
                  }
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.branding_watermark, color: primaryColor),
                title: const Text(
                  'Add Brand',
                  style: TextStyle(color: primaryColor),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddBrandScreen(),
                    ),
                  );
                  if (value != null) {
                    setState(() {
                      _fetchBrands();
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_box, color: primaryColor),
                title: const Text(
                  'Add Product',
                  style: TextStyle(color: primaryColor),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddProductScreen(),
                    ),
                  );
                  if (value != null) {
                    setState(() {
                      _fetchProducts();
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
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
            SizedBox(
              width: double.infinity,
              height: 126,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'stockZen',
                        style: TextStyle(
                          fontFamily: 'Rakkas',
                          color: Colors.white,
                          fontSize: 48,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: CircleAvatar(
                              radius: 21,
                              backgroundColor: Colors.white,
                              child: pickedImage != null
                                  ? GestureDetector(
                                      onTap: () async {
                                        final value = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    const ProfileScreen()));
                                        if (value != null) {
                                          setState(() {
                                            fetchUserImage();
                                          });
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image:
                                                FileImage(File(pickedImage!)),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    const ProfileScreen()));
                                      },
                                      child: const CircleAvatar(
                                          radius: 22,
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.person,
                                            color: primaryColor,
                                            size: 28,
                                          )),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              color: const Color.fromARGB(255, 200, 200, 200),
            ),
            const SizedBox(height: 20),
            buildCustomRow(
                context: context,
                title: 'Categories',
                navigateTo: CategoryListScreen()),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: SizedBox(
                width: double.infinity,
                height: 140,
                child: _isLoadingCategories
                    ? const Center(child: CircularProgressIndicator())
                    : categories.isEmpty
                        ? const Center(
                            child: Text(
                              'No categories yet. Click + to add categories.',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                ProductsViewingScreen(
                                                  categoryID:
                                                      categories[index].id,
                                                  categoryName:
                                                      categories[index].name,
                                                )));
                                  },
                                  child: buildCard(
                                    index,
                                    categories[index],
                                    CategoryModel,
                                    categories[index].name,
                                    categories[index].imagePath,
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            buildCustomRow(
                context: context,
                title: 'Brands',
                navigateTo: BrandListScreen()),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: SizedBox(
                width: double.infinity,
                height: 140,
                child: _isLoadingBrands
                    ? const Center(child: CircularProgressIndicator())
                    : brands.isEmpty
                        ? const Center(
                            child: Text(
                              'No brands yet. Click + to add brands.',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: brands.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductsViewingBrandScreen(
                                          brandID: brands[index].id,
                                          brandName: brands[index].name,
                                        ),
                                      ),
                                    );
                                  },
                                  child: buildCard(
                                    index,
                                    brands[index],
                                    BrandModel,
                                    brands[index].name,
                                    brands[index].imagePath,
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            buildCustomRow(
                context: context,
                title: 'Products',
                navigateTo: ProductListScreen()),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: SizedBox(
                width: double.infinity,
                height: 140,
                child: _isLoadingProducts
                    ? const Center(child: CircularProgressIndicator())
                    : products.isEmpty
                        ? const Center(
                            child: Text(
                              'No products yet. Click + to add products.',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                ProductDetailsScreen(
                                                  product: products[index],
                                                )));
                                  },
                                  child: buildCard(
                                    index,
                                    products[index],
                                    ProductModel,
                                    products[index].productName,
                                    products[index].productImagePath,
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddBottomSheet,
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: primaryColor,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_down),
            label: 'Stock Out',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: onItemTapped,
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget buildCard(
    int index,
    var product,
    var model,
    String title,
    String imagePath,
  ) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 4,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.file(
              File(imagePath),
              height: 140,
              width: 140,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: primaryColor.withOpacity(0.2),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.category,
                    size: 48,
                    color: primaryColor,
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(1),
                ],
              )),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Theme(
                data: Theme.of(context).copyWith(
                  popupMenuTheme: const PopupMenuThemeData(
                    color: primaryColor,
                    textStyle: TextStyle(color: Colors.white),
                  ),
                ),
                child: PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  offset: const Offset(-90, 5),
                  onSelected: (value) {
                    if (value == 'Edit') {
                      if (model == CategoryModel) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) =>
                                    EditCategoryScreen(category: product)));
                      } else if (model == BrandModel) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) =>
                                    EditBrandScreen(brand: product)));
                      } else if (model == ProductModel) {
                        final ProductModel newProduct = product;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => EditProductScreen(
                                      product: newProduct,
                                      productKey: newProduct.id,
                                      productName: newProduct.productName,
                                      brand: newProduct.brand,
                                      category: newProduct.category,
                                      image: newProduct.productImagePath,
                                      color: newProduct.color,
                                      quantity: newProduct.quantity,
                                      price: newProduct.price,
                                      description: newProduct.description,
                                    )));
                      } else {
                        log('nothing selected');
                      }
                    } else if (value == 'Delete') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Delete Product'),
                            content: const Text(
                                'Are you sure you want to delete this product?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel',
                                    style: TextStyle(color: Colors.grey)),
                              ),
                              TextButton(
                                onPressed: () {
                                  ProductDb().deleteProduct(product.id);
                                  _fetchProducts();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Delete',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: 'Edit',
                      child: ListTile(
                        leading: Icon(Icons.edit, color: Colors.white),
                        title:
                            Text('Edit', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'Delete',
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.white),
                        title: Text('Delete',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
