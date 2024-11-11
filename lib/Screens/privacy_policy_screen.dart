import 'package:flutter/material.dart';
import 'package:stockzen/constant.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [primaryColor, primaryColor2],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight)),
          child: AppBar(
            title: Text(
              'Privacy Policy',
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              'Privacy Policy for stockZen',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: const Color.fromARGB(32, 100, 100, 100),
            thickness: 1.5,
          ),
          Text('Privacy Policy'),
          Text('Last updated: ,2024'),
          
        ],
      ),
    );
  }
}
