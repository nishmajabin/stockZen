import 'package:intl/intl.dart';
import 'package:stockzen/functions/sales_db.dart';


Future<Map<String, dynamic>> getRevenueData({DateTime? from, DateTime? to}) async {
  final sales = await getAllSales();

  final startDate = from ?? DateTime(2000); // Default start date if none selected
  final endDate = to ?? DateTime.now(); // Default end date if none selected

  double totalRevenue = 0.0;
  double todaysRevenue = 0.0;
  int totalSales = 0;
  List<double> weeklyRevenue = List.filled(7, 0.0); // For weekly revenue tracking

  final today = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy'); // Define the expected date format

  for (var sale in sales) {
    // Parse the sale date using the defined format
    final saleDate = dateFormat.parse(sale.date); 

    // Check if the saleDate is within the selected range
    if (saleDate.isAfter(startDate.subtract(Duration(days: 1))) && saleDate.isBefore(endDate.add(Duration(days: 1)))) {
      totalRevenue += sale.totalAmount ?? 0.0;
      totalSales++;

      // Check if the sale was made today
      if (sale.date == today) {
        todaysRevenue += sale.totalAmount ?? 0.0;
      }

      // Get the weekday index (0 for Monday, 6 for Sunday)
      final dayOfWeek = (saleDate.weekday - 1) % 7; 
      weeklyRevenue[dayOfWeek] += sale.totalAmount ?? 0.0; // Aggregate revenue for the week
    }
  }

  return {
    'todaysRevenue': todaysRevenue,
    'totalRevenue': totalRevenue,
    'totalSales': totalSales,
    'weeklyRevenue': weeklyRevenue,
  };
}