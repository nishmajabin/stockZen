
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/sales_db.dart';

class RevenuePage extends StatefulWidget {
  const RevenuePage({Key? key}) : super(key: key);

  @override
  State<RevenuePage> createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
  DateTimeRange? selectedDateRange;
  Future<Map<String, dynamic>>? revenueDataFuture;

  @override
  void initState() {
    super.initState();
    revenueDataFuture = getRevenueData(); // Initial fetch
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

    final startDate =
        from ?? DateTime(2000); // Default start date if none selected
    final endDate = to ?? DateTime.now(); // Default end date if none selected

    double totalRevenue = 0.0;
    double todaysRevenue = 0.0;
    int totalSales = 0;
    List<double> monthlyRevenue =
        List.filled(12, 0.0); // For monthly revenue tracking

    final today = DateFormat('dd-MM-yyyy').format(DateTime.now());

    for (var sale in sales) {
      // Parse the sale date from 'dd-MM-yyyy' format
      final saleDate = DateFormat('dd-MM-yyyy').parse(sale.date);

      // Check if the saleDate is within the selected range
      if (saleDate.isAfter(startDate.subtract(Duration(days: 1))) &&
          saleDate.isBefore(endDate.add(Duration(days: 1)))) {
        totalRevenue += sale.totalAmount ?? 0.0;
        totalSales++;

        // Check if the sale was made today
        if (sale.date == today) {
          todaysRevenue += sale.totalAmount ?? 0.0;
        }

        // Get the month index (0 for January, 11 for December)
        final monthIndex = saleDate.month - 1;
        monthlyRevenue[monthIndex] +=
            sale.totalAmount ?? 0.0; // Aggregate revenue for the month
      }
    }

    return {
      'todaysRevenue': todaysRevenue,
      'totalRevenue': totalRevenue,
      'totalSales': totalSales,
      'monthlyRevenue': monthlyRevenue,
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
      appBar: AppBar(
        title: const Text(
          'Revenue',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: _pickDateRange,
          ),
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
          List<double> monthlyRevenue =
              revenueData['monthlyRevenue'] ?? List.filled(12, 0.0);

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
                  _buildRevenueChart(monthlyRevenue),
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
                  '₹${formatCurrency(totalRevenue)}', Colors.green),
            ),
            const SizedBox(width: 16),
            Expanded(
              child:
                  _buildCard('Total Sales', totalSales.toString(), Colors.blue),
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
                  color: Colors.grey[600]),
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

  Widget _buildRevenueChart(List<double> monthlyRevenue) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Revenue',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec'
                          ];
                          return Text(months[value.toInt()]);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('₹${formatCurrency(value)}');
                        },
                      ),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  minX: 0,
                  maxX: 11, // For 12 months
                  minY: 0,
                  maxY: monthlyRevenue.reduce((a, b) => a > b ? a : b),
                  lineBarsData: [
                    LineChartBarData(
                      spots: monthlyRevenue
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                      isCurved: true,
                      color: primaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: primaryColor.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}