import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/screens/brand/edit_brand_screen.dart';
import 'package:stockzen/screens/category/edit_category_screen.dart';
import 'package:stockzen/screens/product/edit_product_screen.dart';
import 'package:stockzen/functions/brand_db.dart';
import 'package:stockzen/functions/category_db.dart';
import 'package:stockzen/functions/product_db.dart';
import 'package:stockzen/models/brand_model.dart';
import 'package:stockzen/models/category_model.dart';
import 'package:stockzen/models/product_model.dart';
import 'package:stockzen/screens/product/product_details_screen.dart';

class CustomVerticalListView extends StatelessWidget {
  final Box box;

  const CustomVerticalListView({
    super.key,
    required this.box,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, value, child) {
          final data = value.values.toList();

          if (data.isEmpty) {
            return const Center(
              child: Text(
                'No items added yet! click + to add!',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = data[index];

              return Container(
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: Container(
                    width: 65,
                    height: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: item.imagePath.isNotEmpty
                          ? DecorationImage(
                              image: FileImage(File(item.imagePath)),
                              fit: BoxFit.cover,
                              onError: (_, __) => null,
                            )
                          : null,
                    ),
                    child: item.imagePath.isEmpty
                        ? const Icon(Icons.category, color: Colors.grey)
                        : null,
                  ),
                  title: Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: item is ProductModel
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quantity: ${item.quantity}',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Price: ₹${item.price}',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      : null,
                  onTap: () {
                    if (item is ProductModel) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => ProductDetailsScreen(product: item),
                        ),
                      );
                    }
                  },
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'Edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'Delete',
                        child: ListTile(
                          leading: Icon(Icons.delete),
                          title: Text('Delete'),
                        ),
                      ),
                    ],
                    onSelected: (value) =>
                        _handleMenuSelection(context, value, item),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value, dynamic item) {
    if (value == 'Edit') {
      if (item is CategoryModel) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => EditCategoryScreen(category: item),
          ),
        );
      } else if (item is BrandModel) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => EditBrandScreen(brand: item),
          ),
        );
      } else if (item is ProductModel) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => EditProductScreen(
              product: item,
              productKey: item.id,
              productName: item.name,
              brand: item.brand,
              category: item.category,
              image: item.imagePath,
              color: item.color,
              quantity: item.quantity,
              price: item.price,
              description: item.description,
            ),
          ),
        );
      }
    } else if (value == 'Delete') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete'),
            content: const Text('Are you sure you want to delete?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () {
                  if (item is ProductModel) {
                    ProductDb().deleteProduct(item.id);
                  } else if (item is CategoryModel) {
                    CategoryDB().deleteCategory(item.id);
                  } else {
                    BrandDb().deleteBrand(item.id);
                  }
                  Navigator.of(context).pop();
                },
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
    }
  }
}
