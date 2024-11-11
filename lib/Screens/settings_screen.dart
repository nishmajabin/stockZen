import 'package:flutter/material.dart';
import 'package:stockzen/Screens/about_us_screen.dart';
import 'package:stockzen/constant.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                secondaryColor,
                Color.fromARGB(239, 186, 209, 229),
                secondaryColor
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.1, 0.5, 1.0])),
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Stack(children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: primaryColor,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  'Settings',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 19,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ]),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Icon(
              Icons.verified_user,
            ),
            title: Text('App Version'),
            subtitle: Text('1.0.0'),
            iconColor: primaryColor,
            textColor: primaryColor,
            titleTextStyle: TextStyle(fontWeight: FontWeight.w500),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => AboutUsScreen()));
            },
            leading: Icon(Icons.info),
            title: Text('About us'),
            textColor: primaryColor,
            iconColor: primaryColor,
            titleTextStyle: TextStyle(fontWeight: FontWeight.w500),
          )
        ],
      ),
    ));
  }
}
