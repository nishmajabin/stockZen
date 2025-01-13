import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:stockzen/screens/custom_appbar.dart';
import 'package:stockzen/screens/sales/sales_add.dart';
import 'package:stockzen/screens/sales/salesbill_detail.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/models/sales_model.dart';
import 'package:stockzen/screens/sales/widgets/custom_row_text.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  List<SalesModel> _sales = []; // List of filtered sales
  List<SalesModel> _allSales = []; // Complete list of sales
  DateTimeRange? _selectedDateRange; // Date range selected by the user

  @override
  void initState() {
    super.initState();
    _fetchSales(); // Fetch sales data when the page is initialized
  }

  Future<void> _fetchSales() async {
    final salesBox = await Hive.openBox<SalesModel>('salesBox');
    setState(() {
      _allSales = salesBox.values.toList();
      _sales = List.from(_allSales); // Copy the entire list to _sales
      _sales.sort((a, b) =>
          b.date.compareTo(a.date)); // Sort sales by date in descending order
    });
    _filterSalesByDateRange(); // Filter sales based on selected date range
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000), // Start date for the picker
      lastDate: DateTime.now(), // End date for the picker
      initialDateRange: _selectedDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(
                const Duration(days: 7)), // Default start date is 7 days ago
            end: DateTime.now(), // Default end date is today
          ),
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked; // Update the selected date range
      });
      _filterSalesByDateRange(); // Filter the sales based on the new date range
    }
  }

  void _filterSalesByDateRange() {
    if (_selectedDateRange == null) {
      _sales = List.from(_allSales); // No date range selected, show all sales
    } else {
      final DateFormat dateFormat =
          DateFormat('dd-MMM-yyyy'); // Date format for parsing
      setState(() {
        _sales = _allSales.where((sale) {
          DateTime saleDate = dateFormat.parse(sale.date);
          return saleDate.isAfter(_selectedDateRange!.start
                  .subtract(const Duration(days: 1))) &&
              saleDate.isBefore(_selectedDateRange!.end.add(const Duration(
                  days: 1))); // Filter sales within the selected range
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Sales',
        actions: [
          IconButton(
              onPressed: () => _selectDate(context),
              icon: Icon(Icons.calendar_today))
        ],
      ),
      body: Column(
        children: [
          // Display selected date range or 'No date range selected' message
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.date_range, color: primaryColor),
                const SizedBox(
                    width: 8), // Add some spacing between icon and text
                Expanded(
                  child: Text(
                    _selectedDateRange == null
                        ? 'No date range selected' // If no date range is selected
                        : 'Selected Range: ${DateFormat('MMM d').format(_selectedDateRange!.start)} - ${DateFormat('MMM d, yyyy').format(_selectedDateRange!.end)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors
                          .grey[700], // Darker shade for better readability
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _sales.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart,
                            size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          'No sales in selected date range',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the calendar to change dates or add a new sale',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _sales.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final sale = _sales[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(148, 156, 186, 208),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SaleDetailsPage(sale: sale),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomRowWidget(
                                    icon: Icons.person,
                                    text:
                                        '${sale.customerName[0].toUpperCase()}${sale.customerName.substring(1).toLowerCase()}',
                                    color: cardColor2,
                                  ),
                                  const SizedBox(height: 8),
                                  CustomRowWidget(
                                    icon: Icons.phone,
                                    text: 'Mobile: ${sale.customerNumber}',
                                    color: primaryColor,
                                  ),
                                  const SizedBox(height: 8),
                                  CustomRowWidget(
                                    icon: Icons.calendar_today,
                                    text: 'Date: ${sale.date}',
                                    color: primaryColor,
                                  ),
                                  const SizedBox(height: 8),
                                  CustomRowWidget(
                                    icon: Icons.attach_money,
                                    text: 'Total Amount: ₹${sale.totalAmount}',
                                    color:
                                        const Color.fromARGB(255, 17, 65, 19),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),

      // Floating action button to add a new sale
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const AddSaleScreen()), // Navigate to add sale screen
          ).then((_) {
            _fetchSales(); // Refresh sales after adding a new one
          });
        },
        icon: const Icon(Icons.add,
            color: Colors.white), // Plus icon for the button
        label: const Text('Add Sale',
            style: TextStyle(color: Colors.white)), // Button label
        backgroundColor: primaryColor, // Button color
      ),
    );
  }
}
