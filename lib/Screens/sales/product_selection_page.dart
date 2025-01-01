// import 'package:flutter/material.dart';
// import 'package:stockzen/functions/product_db.dart';
// import 'package:stockzen/models/product_model.dart';

// class ProductSelectionBottomSheet extends StatelessWidget {
//   final ProductDb productDb = ProductDb(); // Initialize the database instance

//   ProductSelectionBottomSheet({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<ProductModel>>(
//       future: _fetchProducts(), // Fetch products from the database
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(), // Show loading indicator
//           );
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text('Error: ${snapshot.error}'), // Show error message
//           );
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(
//             child: Text('No products available.'), // Show empty state message
//           );
//         }

//         final products = snapshot.data!;

//         return Container(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Select a Product',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const Divider(),
//               Expanded(
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: products.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(products[index].name),
//                       subtitle: Text(products[index].price.toString()),
//                       // Display product name
//                       onTap: () {
//                         Navigator.pop(
//                             context, products[index]); // Pass selected product
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<List<ProductModel>> _fetchProducts() async {
//     return productDb.getProduct(); // Fetch products from the database
//   }
// }
