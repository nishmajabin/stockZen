import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:stockzen/models/product_model.dart';
import 'package:stockzen/screens/stock%20out/widgets/custom_product_card.dart';

class StockSectionWidget extends StatelessWidget {
  final String title;
  final List<ProductModel> products;
  final Color color;
  final String sectionKey;
  final bool isExpanded;
  final Function(String) onSectionTap;

  const StockSectionWidget({
    Key? key,
    required this.title,
    required this.products,
    required this.color,
    required this.sectionKey,
    required this.isExpanded,
    required this.onSectionTap,
  }) : super(key: key);

  Color _getBackgroundColorForSection(String sectionKey) {
    switch (sectionKey) {
      case 'wellStocked':
        return Colors.green.shade50;
      case 'lowStock':
        return Colors.orange.shade50;
      case 'outOfStock':
        return Colors.red.shade50;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GestureDetector(
            onTap: () => onSectionTap(sectionKey),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      products.length.toString(),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: AnimationLimiter(
            child: Column(
              children: List.generate(
                products.length,
                (index) => AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: ProductListItem(
                        product: products[index],
                        backgroundColor: _getBackgroundColorForSection(sectionKey),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}