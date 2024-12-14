import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stockzen/Screens/brand/edit_brand_screen.dart';
import 'package:stockzen/Screens/category/edit_category_screen.dart';
import 'package:stockzen/Screens/product/edit_product_screen.dart';
import 'package:stockzen/functions/brand_db.dart';
import 'package:stockzen/functions/category_db.dart';
import 'package:stockzen/functions/product_db.dart';
import 'package:stockzen/models/brand_model.dart';
import 'package:stockzen/models/category_model.dart';
import 'package:stockzen/models/product_model.dart';

class CustomHorizontalListView extends StatelessWidget {
  final Box box;
  const CustomHorizontalListView({
    super.key,
    required this.box,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 15),
        child: SizedBox(
          width: double.infinity,
          height: 140,
          child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, value, child) {
                final data = value.values.toList();
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: GestureDetector(
                        child: Container(
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
                                  File(data[index].imagePath),
                                  height: 140,
                                  width: 140,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.withOpacity(0.2),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.category,
                                        size: 48,
                                        color: Colors.grey,
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
                                      data[index].name,
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
                                        textStyle:
                                            TextStyle(color: Colors.white),
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
                                          final item = data[index];
                                          if (item is CategoryModel) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (ctx) =>
                                                    EditCategoryScreen(
                                                  category: data[index],
                                                ),
                                              ),
                                            );
                                          } else if (item is BrandModel) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (ctx) =>
                                                    EditBrandScreen(
                                                  brand: data[index],
                                                ),
                                              ),
                                            );
                                          } else if (item is ProductModel) {
                                            final ProductModel newProduct =
                                                data[index];
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (ctx) =>
                                                    EditProductScreen(
                                                  product: newProduct,
                                                  productKey: newProduct.id,
                                                  productName:
                                                      newProduct.name,
                                                  brand: newProduct.brand,
                                                  category: newProduct.category,
                                                  image: newProduct.imagePath,
                                                  color: newProduct.color,
                                                  quantity: newProduct.quantity,
                                                  price: newProduct.price,
                                                  description:
                                                      newProduct.description,
                                                ),
                                              ),
                                            );
                                          } else {
                                            debugPrint('Nothing selected');
                                          }
                                        } else if (value == 'Delete') {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Delete Product'),
                                                content: const Text(
                                                    'Are you sure you want to delete this product?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Cancel',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      final item = data[index];
                                                      if (item
                                                          is ProductModel) {
                                                        ProductDb()
                                                            .deleteProduct(
                                                                item.id);
                                                      } else if (item
                                                          is CategoryModel) {
                                                        CategoryDB()
                                                            .deleteCategory(
                                                                item.id);
                                                      } else {
                                                        BrandDb().deleteBrand(
                                                            item.id);
                                                      }
                                                      // ProductDb().deleteProduct(widget.product.id);
                                                      // _fetchProducts();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Delete',
                                                        style: TextStyle(
                                                            color: Colors.red)),
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
                                            leading: Icon(Icons.edit,
                                                color: Colors.white),
                                            title: Text('Edit',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'Delete',
                                          child: ListTile(
                                            leading: Icon(Icons.delete,
                                                color: Colors.white),
                                            title: Text('Delete',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
        ));
  }
}
        // child: isLoading
        //     ? const Center(child: CircularProgressIndicator())
        //     : itemCount == 0
        //         ? Center(
        //             child: Text(
        //               emptyMessage,
        //               style: const TextStyle(color: Colors.white),
        //             ),
        //           )
        //         : ListView.builder(
        //             scrollDirection: Axis.horizontal,
        //             itemCount: itemCount,
        //             itemBuilder: (context, index) {
        //               return Padding(
        //                 padding: const EdgeInsets.only(right: 16.0),
        //                 child: GestureDetector(
        //                   onTap: () => Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                       builder: (ctx) => onNavigate(context, index),
        //                     ),
        //                   ),
        //                   child: childBuilder(context, index),
        //                 ),
        //               );
        //             },
        //           ),
          // final int itemCount;
  // final Widget Function(BuildContext context, int index) childBuilder;
  // final Widget Function(BuildContext context, int index) onNavigate;
  // final bool isLoading;
  // final String emptyMessage;
      // required this.model,
    // required this.itemCount,
    // required this.childBuilder,
    // required this.onNavigate,
    // this.isLoading = false,
    // this.emptyMessage = 'No items available. Please add some.',
              // onTap: () => Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (ctx) => onNavigate(context, index),
                        //   ),
                        // ),
                        // child: childBuilder(context, index),
                        // child: Container(
                        //   width: 100,
                        //   height: 80,
                        //   child: Column(
                        //     children: [Text(data[index].name)],
                        //   ),
                        // ),
                         // final String model;