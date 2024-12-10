import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:stockzen/Screens/inventory/inventory_screen.dart';
import 'package:stockzen/Screens/sales/sales_add.dart';
import 'package:stockzen/Screens/sales/salesbill_detail.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/models/sales_model.dart';

class SalesPage extends StatefulWidget {
  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  List<SalesModel> _sales = []; // List of filtered sales
  List<SalesModel> _allSales = []; // Complete list of sales
  DateTimeRange? _selectedDateRange; // Date range selected by the user
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchSales(); // Fetch sales data when the page is initialized
  }

  // Fetch sales data from Hive database and filter by date range
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

  // Show the date range picker to allow user to select a date range
  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000), // Start date for the picker
      lastDate: DateTime.now(), // End date for the picker
      initialDateRange: _selectedDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(
                Duration(days: 7)), // Default start date is 7 days ago
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

  // Filter sales based on the selected date range
  void _filterSalesByDateRange() {
    if (_selectedDateRange == null) {
      _sales = List.from(_allSales); // No date range selected, show all sales
    } else {
      final DateFormat dateFormat =
          DateFormat('dd-MM-yyyy'); // Date format for parsing
      setState(() {
        _sales = _allSales.where((sale) {
          DateTime saleDate = dateFormat.parse(sale.date);
          return saleDate.isAfter(
                  _selectedDateRange!.start.subtract(Duration(days: 1))) &&
              saleDate.isBefore(_selectedDateRange!.end.add(
                  Duration(days: 1))); // Filter sales within the selected range
        }).toList();
      });
    }
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InventoryScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SalesPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable back button
        title: const Text('Sales', style: TextStyle(color: Colors.white)),
        centerTitle: true, // Center the title
        backgroundColor: primaryColor, // Set the app bar color
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () => _selectDate(
                context), // Open date picker when the calendar icon is pressed
          ),
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
                Icon(Icons.date_range, color: primaryColor),
                SizedBox(width: 8), // Add some spacing between icon and text
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
                            size: 80,
                            color: Colors.grey[
                                400]), // Display an icon when no sales are available
                        SizedBox(height: 16),
                        Text(
                          'No sales in selected date range',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap the calendar to change dates or add a new sale',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount:
                        _sales.length, // Total number of sales to display
                    separatorBuilder: (context, index) =>
                        Divider(), // Divider between list items
                    itemBuilder: (context, index) {
                      final sale = _sales[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: primaryColor,
                          child: Text(
                            sale.customerName[0]
                                .toUpperCase(), // First letter of customer name
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(sale.customerName,
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.bold)), // Display customer name
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Phone: ${sale.customerNumber}'), // Display customer number
                            Text('Date: ${sale.date}'), // Display sale date
                          ],
                        ),
                        trailing: Icon(Icons
                            .chevron_right), // Right arrow icon for navigation
                        onTap: () {
                          // Navigate to the sale details page when tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SaleDetailsPage(sale: sale),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      // Floating action button to add a new sale
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddSaleScreen()), // Navigate to add sale screen
          ).then((_) {
            _fetchSales(); // Refresh sales after adding a new one
          });
        },
        icon: Icon(Icons.add, color: Colors.white), // Plus icon for the button
        label: Text('Add Sale',
            style: TextStyle(color: Colors.white)), // Button label
        backgroundColor: primaryColor, // Button color
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_down),
            label: 'Stock Out',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: onItemTapped,
        backgroundColor: Colors.white,
      ),
    );
  }
}
