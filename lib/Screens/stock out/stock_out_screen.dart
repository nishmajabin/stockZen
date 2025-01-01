import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/models/product_model.dart';

class StockAvailabilityPage extends StatefulWidget {
  @override
  _StockAvailabilityPageState createState() => _StockAvailabilityPageState();
}

class _StockAvailabilityPageState extends State<StockAvailabilityPage> {
  // Use ValueNotifier to track expanded states for each section
  final ValueNotifier<Map<String, bool>> _expandedSections = ValueNotifier({
    'outOfStock': false,
    'lowStock': false,
    'wellStocked': false, 
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Availability', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final products = snapshot.data ?? [];
            final outOfStockProducts = products.where((product) => product.quantity == 0).toList();
            final lowStockProducts = products.where((product) => product.quantity < 3 && product.quantity > 0).toList();
            final wellStockedProducts = products.where((product) => product.quantity >= 3).toList();

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildStockSummary(products),
                ),
                // Out of Stock Section
                _buildStockSection('Out of Stock', outOfStockProducts, Colors.red.shade400, 'outOfStock'),
                // Low Stock Section
                _buildStockSection('Low Stock', lowStockProducts, Colors.orange.shade500, 'lowStock'),
                // Well Stocked Section
                _buildStockSection('Well Stocked', wellStockedProducts, Colors.green.shade500, 'wellStocked'),
              ],
            );
          }
        },
      ),
    );
  }

  Future<List<ProductModel>> _fetchProducts() async {
    final box = await Hive.openBox<ProductModel>('products');
    return box.values.toList();
  }

  Widget _buildStockSummary(List<ProductModel> products) {
    final totalProducts = products.length;
    final outOfStock = products.where((p) => p.quantity == 0).length;
    final lowStock = products.where((p) => p.quantity < 3 && p.quantity > 0).length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              _buildSummaryItem('Total Products', totalProducts, Colors.blue),
              _buildSummaryItem('Out of Stock', outOfStock, Colors.red),
              _buildSummaryItem('Low Stock', lowStock, Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, int value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value.toString(),
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockSection(String title, List<ProductModel> products, Color color, String sectionKey) {
    return ValueListenableBuilder<Map<String, bool>>(
      valueListenable: _expandedSections,
      builder: (context, expandedState, child) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _expandedSections.value[sectionKey] = !_expandedSections.value[sectionKey]!; // Toggle expansion
                      _expandedSections.notifyListeners(); // Notify listeners to rebuild
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(
                              products.length.toString(),
                              style: TextStyle(color: color, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: SizedBox.shrink(), // Empty widget when collapsed
                    secondChild: AnimationLimiter(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        separatorBuilder: (context, index) => Divider(height: 1),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: ListTile(
                                  title: Text(product.name),
                                  subtitle: Text('Quantity: ${product.quantity}'),
                                  onTap: () {
                                    // TODO: Implement product detail view
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    crossFadeState: expandedState[sectionKey]! ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300), // Animation duration
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}