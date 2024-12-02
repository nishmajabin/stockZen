import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockzen/Screens/sign_in_screen.dart';
import 'package:stockzen/functions/userdb.dart';

import 'package:stockzen/Screens/getstarted_screen.dart';
import 'package:stockzen/Screens/inventory/inventory_screen.dart';
import 'package:stockzen/main.dart';
import '../constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late bool signed;

  @override
  void initState() {
    super.initState();
    checkLogin().then((_) {
      Future.delayed(const Duration(seconds: 3), () async {
        bool? logoutOrnot = await getSignedOrnot();

        if (signed) {
          if (logoutOrnot == true) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const InventoryScreen()));
          } else {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const SignInScreen()));
          }
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const GetstartedScreen()));
        }
      });
    });
  }

  Future<bool?> getSignedOrnot() async {
    final sharedpref = await SharedPreferences.getInstance();
    return sharedpref.getBool(userLogged) ?? false;
  }

  Future<void> checkLogin() async {
    signed = await checkUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 92, 125, 152),
              Color.fromARGB(255, 145, 171, 194),
              Color.fromARGB(255, 92, 125, 152),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/logo.png'),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'stockZen',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 25,
                color: primaryColor,
                fontWeight: FontWeight.w900,
                fontFamily: 'OleoScript',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
