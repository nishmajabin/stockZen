import 'package:flutter/material.dart';
import 'package:stockzen/Screens/inventory/inventory_screen.dart';
import 'package:stockzen/Screens/sales/sales_billing.dart';
import 'package:stockzen/constant.dart';

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({super.key});

  @override
  CustomBottomNavigationState createState() => CustomBottomNavigationState();
}

class CustomBottomNavigationState extends State<CustomBottomNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InventoryScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SalesPage()),
        );
        break;
      case 2:
        // Add logic for Stock Out
        break;
      case 3:
        // Add logic for Analytics
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
      selectedItemColor: primaryColor, // Replace with your `primaryColor`
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      backgroundColor: Colors.white,
    );
  }
}
