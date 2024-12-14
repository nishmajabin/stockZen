
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stockzen/Screens/category/products_viewing_categorised.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/category_db.dart';
import 'package:stockzen/models/category_model.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CategoryModel> categories = [];
  final CategoryDB _categoryDbFunction = CategoryDB();
  bool isLoadingCategory = true;
  List<CategoryModel> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _searchController.addListener(() {
      _filterCategories(_searchController.text);
    });
  }

  void _fetchCategories() async {
    setState(() {
      isLoadingCategory = true;
    });

    try {
      final fetchedCategories = await _categoryDbFunction.getCategories();
      setState(() {
        categories = fetchedCategories;
        filteredCategories = List.from(categories);
      });
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      setState(() {
        isLoadingCategory = false;
      });
    }
  }

  void _filterCategories(String query) {
    setState(() {
      filteredCategories = categories
          .where((category) =>
              (category.name.toLowerCase()).contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, primaryColor2],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: AppBar(
            title: const Text('All Categories'),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: isLoadingCategory
                ? const Center(child: CircularProgressIndicator())
                : filteredCategories.isEmpty
                    ? const Center(child: Text("No categories found"))
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredCategories.length,
                        itemBuilder: (context, index) {
                          final category = filteredCategories[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => ProductsViewingScreen(
                                    categoryID: category.id,
                                    categoryName: category.name,
                                  ),
                                ),
                              );
                            },
                            child: buildCategoryCard(
                              category.name,
                              category.imagePath,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryCard(String title, String? imagePath) {
    return Card(
      color: const Color.fromARGB(199, 7, 46, 74),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            imagePath != null && File(imagePath).existsSync()
                ? Image.file(
                    File(imagePath),
                    height: 155,
                    fit: BoxFit.cover,
                  )
                : const Center(
                    child: Icon(
                      Icons.category,
                      size: 48,
                      color: primaryColor,
                    ),
                  ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';.
// import 'package:stockzen/Screens/category/products_viewing_categorised.dart';
// import 'package:stockzen/constant.dart';
// import 'package:stockzen/functions/category_db.dart';
// import 'package:stockzen/models/category_model.dart';
// import 'package:stockzen/models/product_model.dart';

// class CategoryListScreen extends StatefulWidget {
//   const CategoryListScreen({super.key});

//   @override
//   State<CategoryListScreen> createState() => _CategoryListScreenState();
// }

// class _CategoryListScreenState extends State<CategoryListScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   List<CategoryModel> categories = [];
//   final CategoryDB _categoryDbFunction = CategoryDB();
//   bool isLoadingCategory = true;
//   List<ProductModel> products = [];
//   List<CategoryModel> filteredCategories = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchCategories();
//     _searchController.addListener(() {
//       _filterCategories(_searchController.text);
//     });
//   }

//   void _fetchCategories() async {
//     setState(() {
//       isLoadingCategory = true;
//     });

//     try {
//       final fetchedCategories = _categoryDbFunction.getCategories();
//       setState(() {
//         categories = fetchedCategories;
//         filteredCategories = categories;
//         //  _filteredCategories = fetchedCategories;
//       });
//     } catch (e) {
//       print("Error fetching categories: $e");
//     } finally {
//       setState(() {
//         isLoadingCategory = false;
//       });
//     }
//   }

//   void _filterCategories(String query) {
//     filteredCategories = categories.where(
//       (category) {
//         final nameLower = category.name.toLowerCase();
//         final searchLower = query.toLowerCase();
//         return nameLower.contains(searchLower);
//       },
//     ).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(kToolbarHeight),
//           child: Container(
//             decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                     colors: [primaryColor, primaryColor2],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight)),
//             child: AppBar(
//               title: const Text(
//                 'All Categories',
//               ),
//               backgroundColor: Colors.transparent,
//               foregroundColor: Colors.white,
//               centerTitle: true,
//             ),
//           ),
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: _searchController,
//                 decoration: const InputDecoration(
//                   labelText: 'Search',
//                   prefixIcon: Icon(Icons.search),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: ValueListenableBuilder(
//                   valueListenable:
//                       Hive.box<CategoryModel>('categories').listenable(),
//                   builder: (context, value, child) {
//                     // final datas = value.values.toList();
//                     return GridView.builder(
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 16,
//                         mainAxisSpacing: 16,
//                       ),
//                       itemCount: filteredCategories.length,
//                       itemBuilder: (context, index) {
//                         final category = filteredCategories[index];
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (ctx) => ProductsViewingScreen(
//                                         // categoryID: datas[index].id,
//                                         categoryID: category.id,
//                                         categoryName: category.name)));
//                           },
//                           child: buildCategoryCard(
//                             category.name,
//                             category.imagePath,
//                           ),
//                         );
//                       },
//                     );
//                   }),
//             ),
//           ],
//         ));
//   }

//   Widget buildCategoryCard(String title, String imagepath) {
//     return GestureDetector(
//       child: Card(
//         color: const Color.fromARGB(199, 7, 46, 74),
//         elevation: 4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: Stack(
//             children: [
//               Image.file(
//                 File(imagepath),
//                 height: 155,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return const Icon(
//                     Icons.category,
//                     size: 48,
//                     color: primaryColor,
//                   );
//                 },
//               ),
//               const SizedBox(height: 8),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 6.5),
//                   child: Text(
//                     title,
//                     style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//    // body: _isLoadingCategory
//             //     ? const Center(child: CircularProgressIndicator())
//             //     : categories.isEmpty
//             //         ? const Center(
//             //             child: Text(
//             //               'No categories added yet!',
//             //               style: TextStyle(color: primaryColor, fontSize: 16),
//             //             ),
//             //           )
//             //         :

//             //         Padding(
//             //             padding: const EdgeInsets.all(16.0),
//             //             child: GridView.builder(
//             //               gridDelegate:
//             //                   const SliverGridDelegateWithFixedCrossAxisCount(
//             //                 crossAxisCount: 2,
//             //                 crossAxisSpacing: 16,
//             //                 mainAxisSpacing: 16,
//             //               ),
//             //               itemCount: categories.length,
//             //               itemBuilder: (context, index) {
//             //                 return GestureDetector(
//             //                   onTap: () {
//             //                     Navigator.push(
//             //                         context,
//             //                         MaterialPageRoute(
//             //                             builder: (ctx) => ProductsViewingScreen(
//             //                                 categoryID: categories[index].id,
//             //                                 categoryName: categories[index].name)));
//             //                   },
//             //                   child: buildCategoryCard(
//             //                     categories[index].name,
//             //                     categories[index].imagePath,
//             //                   ),
//             //                 );
//             //               },
//             //             ),
//             //           ),