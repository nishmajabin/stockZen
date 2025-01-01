import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:stockzen/Screens/inventory/inventory_screen.dart';
import 'package:stockzen/Screens/sales/sales_billing.dart';
import 'package:stockzen/Screens/stock%20out/stock_out_screen.dart';
import 'package:stockzen/Screens/analytics/analytics_screen.dart';
import 'package:stockzen/constant.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({
    super.key,
    this.title,
  });
  final String? title;

  @override
  BottomNavPageState createState() => BottomNavPageState();
}

class BottomNavPageState extends State<BottomNavPage> {
  int selectedPos = 0;

  double bottomNavBarHeight = 60;

  List<TabItem> tabItems = List.of(
    [
      TabItem(
        Icons.inventory_2,
        "Inventory",
        primaryColor,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,

        ),
      ),
      TabItem(
        Icons.receipt_long,
        "Sales",
        primaryColor,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      TabItem(
        Icons.trending_down,
        "Stock Out",
        primaryColor,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      TabItem(
        Icons.bar_chart,
        "Analytics",
        primaryColor,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );

  late CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(selectedPos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: bottomNavBarHeight),
            child: bodyContainer(),
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomNav())
        ],
      ),
    );
  }

  Widget bodyContainer() {
    Widget selectedPage;
    switch (selectedPos) {
      case 0:
        selectedPage = const InventoryScreen();
        break;
      case 1:
        selectedPage = SalesPage();
        break;
      case 2:
        selectedPage =  StockAvailabilityPage();
        break;
      case 3:
        selectedPage = const RevenuePage();
        break;
      default:
        selectedPage = const InventoryScreen();
        break;
    }

    return selectedPage;
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      selectedPos: selectedPos,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: primaryColor,
      backgroundBoxShadow: const <BoxShadow>[
        BoxShadow(color: Colors.black45, blurRadius: 10.0),
      ],
      animationDuration: const Duration(milliseconds: 300),
      selectedCallback: (int? selectedPos) {
        setState(() {
          this.selectedPos = selectedPos ?? 0;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }
}
