import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stockzen/models/product_model.dart';
import 'package:stockzen/screens/custom_appbar.dart';
import 'package:stockzen/screens/stock%20out/widgets/custom_stock_section.dart';
import 'package:stockzen/screens/stock%20out/widgets/custom_stock_summary.dart';

// Add the StatefulWidget class
class StockAvailabilityPage extends StatefulWidget {
  const StockAvailabilityPage({super.key});

  @override
  State<StockAvailabilityPage> createState() => _StockAvailabilityPageState();
}

class _StockAvailabilityPageState extends State<StockAvailabilityPage> {
  final ValueNotifier<Map<String, bool>> _expandedSections = ValueNotifier({
    'outOfStock': false,
    'lowStock': false,
    'wellStocked': false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Stock Availability'),
      body: FutureBuilder<List<ProductModel>>(
        future: _fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final products = snapshot.data ?? [];
            final outOfStockProducts = products.where((product) => product.quantity == 0).toList();
            final lowStockProducts = products.where((product) => product.quantity <= 5 && product.quantity > 0).toList();
            final wellStockedProducts = products.where((product) => product.quantity > 5).toList();

            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(8))),
                SliverToBoxAdapter(
                  child: StockSummaryWidget(products: products),
                ),
                SliverToBoxAdapter(
                  child: ValueListenableBuilder<Map<String, bool>>(
                    valueListenable: _expandedSections,
                    builder: (context, expandedState, _) {
                      return Column(
                        children: [
                          StockSectionWidget(
                            title: 'Out of Stock',
                            products: outOfStockProducts,
                            color: Colors.red.shade400,
                            sectionKey: 'outOfStock',
                            isExpanded: expandedState['outOfStock']!,
                            onSectionTap: _toggleSection,
                          ),
                          StockSectionWidget(
                            title: 'Low Stock',
                            products: lowStockProducts,
                            color: Colors.orange.shade500,
                            sectionKey: 'lowStock',
                            isExpanded: expandedState['lowStock']!,
                            onSectionTap: _toggleSection,
                          ),
                          StockSectionWidget(
                            title: 'Well Stocked',
                            products: wellStockedProducts,
                            color: Colors.green.shade500,
                            sectionKey: 'wellStocked',
                            isExpanded: expandedState['wellStocked']!,
                            onSectionTap: _toggleSection,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _toggleSection(String sectionKey) {
    _expandedSections.value = {
      ..._expandedSections.value,
      sectionKey: !_expandedSections.value[sectionKey]!,
    };
  }

  Future<List<ProductModel>> _fetchProducts() async {
    final box = await Hive.openBox<ProductModel>('products');
    return box.values.toList();
  }
}