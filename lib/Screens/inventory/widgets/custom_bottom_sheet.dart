import 'package:flutter/material.dart';
import 'package:stockzen/Screens/brand/add_brand_screen.dart';
import 'package:stockzen/Screens/category/add_category_screen.dart';
import 'package:stockzen/Screens/product/add_product_screen.dart';
import 'package:stockzen/constant.dart';

class CustomWidget extends StatelessWidget {
  const CustomWidget({super.key});

  FloatingActionButton getFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showAddBottomSheet(context),
      backgroundColor: Colors.white,
      child: const Icon(
        Icons.add,
        color: primaryColor,
        size: 30,
      ),
    );
  }

  void showAddBottomSheet(BuildContext context) {
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
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddCategoryScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.branding_watermark, color: primaryColor),
                title: const Text(
                  'Add Brand',
                  style: TextStyle(color: primaryColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddBrandScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_box, color: primaryColor),
                title: const Text(
                  'Add Product',
                  style: TextStyle(color: primaryColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddProductScreen(),
                    ),
                  );
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
    return Container();
  }
}
