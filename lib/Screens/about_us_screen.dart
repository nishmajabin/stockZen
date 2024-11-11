import 'package:flutter/material.dart';
import 'package:stockzen/constant.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        secondaryColor,
        Color.fromARGB(239, 186, 209, 229),
        secondaryColor
      ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Stack(children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: primaryColor,
                ),
              ),
            ),
            const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  'About us',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 19,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ]),
          const SizedBox(
            height: 30,
          ),
          const Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'Welcome to stockZen!',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              )),
          const SizedBox(
            height: 15,
          ),
          const Text.rich(TextSpan(children: [
            TextSpan(
              text: 'stockZen',
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  height: 1.5),
            ),
            TextSpan(
              text: '''
 is a versatile stock management application aimed at 
helping users streamline the process of tracking and organizing
products. Whether it involves adding items, categorizing them 
by brand or type, managing stock quantities, or monitoring sales
data, stockZen offers a comprehensive solution for efficient 
stock management.
''',
              style: TextStyle(color: primaryColor, height: 1.5),
            )
          ])),
          const SizedBox(
            height: 15,
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                'Main Features',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const ListTile(
            leading: Text(
              '•',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            title: Text(
              'Easily add and organize products',
              style: TextStyle(fontSize: 14),
            ),
            textColor: primaryColor,
          ),
          const ListTile(
            leading: Text(
              '•',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            title: Text(
              'Filter items by type or brand',
              style: TextStyle(fontSize: 14),
            ),
            textColor: primaryColor,
          ),
          const ListTile(
            leading: Text(
              '•',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            title: Text(
              'Manage stock levels: Identify how, out-of-stock, or well-supplied item',
              style: TextStyle(fontSize: 14),
            ),
            textColor: primaryColor,
          ),
          const ListTile(
            leading: Text(
              '•',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            title: Text(
              'Track sales and apply date filters',
              style: TextStyle(fontSize: 14),
            ),
            textColor: primaryColor,
          ),
          const ListTile(
            leading: Text(
              '•',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            title: Text(
              'Access revenue totals and best-selling products',
              style: TextStyle(fontSize: 14),
            ),
            textColor: primaryColor,
          ),
          const ListTile(
            leading: Text(
              '•',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            title: Text(
              'Quickly check product availability',
              style: TextStyle(fontSize: 14),
            ),
            textColor: primaryColor,
          ),
          const SizedBox(
            height: 20,
          ),
          const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'About Us',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              )),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              '''
stockZen was developed using Flutter and Hive, created to meet
the needs of businesses of all sizes. It delivers a user-friendly
and seamless experience, simplifying the inventory management 
process to make it more efficient and accessible.
''',
              style: TextStyle(height: 1.5),
            ),
          ),
          SizedBox(
            height: 35,
          ),
          Text(
            'Version 1.0',
            style: TextStyle(color: Color.fromARGB(255, 52, 99, 130)),
          ),
        ],
      ),
    ));
  }
}
