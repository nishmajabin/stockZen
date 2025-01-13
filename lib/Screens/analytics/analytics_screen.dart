import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/sales_db.dart';
import 'package:stockzen/models/sales_model.dart';
import 'package:stockzen/screens/custom_appbar.dart';

class RevenuePage extends StatefulWidget {
  const RevenuePage({super.key});

  @override
  State<RevenuePage> createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
  DateTimeRange? selectedDateRange;
  Future<Map<String, dynamic>>? revenueDataFuture;
  List<SalesModel> salesData = [];

  @override
  void initState() {
    super.initState();
    revenueDataFuture = getRevenueData();
  }

  Future<void> _pickDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: selectedDateRange,
    );

    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
        revenueDataFuture = getRevenueData(from: picked.start, to: picked.end);
      });
    }
  }

  Future<Map<String, dynamic>> getRevenueData(
      {DateTime? from, DateTime? to}) async {
    final sales = await getAllSales();
    salesData = sales; // Store sales data for pie chart
    final startDate = from ?? DateTime(2000);
    final endDate = to ?? DateTime.now();

    double totalRevenue = 0.0;
    double todaysRevenue = 0.0;
    int totalSales = 0;
    List<double> monthlyRevenue = List.filled(12, 0.0);

    final today = DateFormat('dd-MMM-yyyy').format(DateTime.now());

    for (var sale in sales) {
      final saleDate = DateFormat('dd-MMM-yyyy').parse(sale.date);

      if (saleDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          saleDate.isBefore(endDate.add(const Duration(days: 1)))) {
        totalRevenue += sale.totalAmount ?? 0.0;
        totalSales++;

        if (sale.date == today) {
          todaysRevenue += sale.totalAmount ?? 0.0;
        }

        final monthIndex = saleDate.month - 1;
        monthlyRevenue[monthIndex] += sale.totalAmount ?? 0.0;
      }
    }

    return {
      'todaysRevenue': todaysRevenue,
      'totalRevenue': totalRevenue,
      'totalSales': totalSales,
      'monthlyRevenue': monthlyRevenue,
      'sales': sales,
    };
  }

  String formatCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}m';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    } else {
      return value.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Revenue',
        actions: [
          IconButton(
              onPressed: _pickDateRange, icon: Icon(Icons.calendar_month))
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: revenueDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          Map<String, dynamic> revenueData = snapshot.data!;
          double todaysRevenue = revenueData['todaysRevenue'];
          double totalRevenue = revenueData['totalRevenue'];
          int totalSales = revenueData['totalSales'];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedDateRange == null
                        ? 'No date range selected'
                        : 'Selected Range: ${DateFormat('MMM d').format(selectedDateRange!.start)} - ${DateFormat('dd-MM-yyyy').format(selectedDateRange!.end)}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryCards(totalRevenue, totalSales, todaysRevenue),
                  const SizedBox(height: 24),
                  _buildPieChartSection(salesData),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(
      double totalRevenue, int totalSales, double todaysRevenue) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildCard('Total Revenue',
                  '₹${formatCurrency(totalRevenue)}', priceColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCard(
                  'Total Sales', totalSales.toString(), primaryColor),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCard(String title, String value, Color valueColor) {
    return Card(
      elevation: 4,
      color: const Color.fromARGB(175, 215, 238, 255),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 79, 78, 78)),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: valueColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartSection(List<SalesModel> sales) {
    Map<String, int> productCount = {};

    // Calculate total quantity for each product across all sales
    for (var sale in sales) {
      sale.productQuantities.forEach((productId, quantity) {
        productCount[productId] = (productCount[productId] ?? 0) + quantity;
      });
    }

    // Handle empty sales data
    if (productCount.isEmpty) {
      return const Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No sales data available',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    }

    var sortedProducts = productCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    var top5Products = sortedProducts.take(5).toList();

    int totalProducts = top5Products.fold(0, (sum, item) => sum + item.value);

    List<Color> colors = [
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.blue,
      Colors.purple,
    ];

    List<PieChartSectionData> sections =
        top5Products.asMap().entries.map((entry) {
      return PieChartSectionData(
        color: colors[entry.key],
        value: entry.value.value.toDouble(),
        title: '',
        radius: 40,
      );
    }).toList();

    return FutureBuilder<List<String>>(
      future: Future.wait(top5Products.map((e) => getProductNameById(e.key))),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final productNames = snapshot.data!;

        if (productNames.length != top5Products.length) {
          return const Center(child: Text('Error loading product names'));
        }

        return Card(
          color: const Color.fromARGB(200, 244, 244, 244),
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Top 5 Selling Products',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 95, 94, 94),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 300,
                  child: Stack(
                    children: [
                      if (sections.isNotEmpty)
                        PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 80,
                            sections: sections,
                          ),
                        ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 73, 72, 72),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              totalProducts.toString(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children: top5Products.asMap().entries.map((entry) {
                    final productName = productNames[entry.key];
                    final saleQuantity = entry.value.value;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors[entry.key],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "$productName: $saleQuantity",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
