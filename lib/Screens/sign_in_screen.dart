import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockzen/Screens/inventory/inventory_screen.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/user_db.dart';
import 'package:stockzen/main.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Stack(
          children: [
            Center(
              child: Container(
                width: 420,
                height: 470,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [primaryColor, primaryColor2],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(27),
                        bottomRight: Radius.circular(27))),
              ),
            ),
            Container(
              width: double.infinity,
              height: 450,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        secondaryColor,
                        Color.fromARGB(255, 199, 215, 230),
                        secondaryColor
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.1, 0.5, 0.9]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(27),
                      bottomRight: Radius.circular(27))),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    '   Hey\nLogin!!',
                    style: TextStyle(
                        fontSize: 50,
                        color: primaryColor,
                        fontFamily: 'Rakkas',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  controller: nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person,
                      color: primaryColor,
                    ),
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(30)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: primaryColor,
                          width: 1.7,
                        )),
                    labelText: 'Username',
                    labelStyle: const TextStyle(
                        color: primaryColor, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  controller: passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: primaryColor,
                    ),
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(30)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: primaryColor,
                          width: 1.7,
                        )),
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                        color: primaryColor, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryColor, primaryColor2],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {
                    signIn();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 13),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }

  Future<void> signIn() async {
    final user = await getUser();
    if (user.name.toUpperCase() == nameController.text.toUpperCase() &&
        user.password.toUpperCase() == passwordController.text.toUpperCase()) {
      final sharedpref = await SharedPreferences.getInstance();
      sharedpref.setBool(userLogged, true);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (ctx) => const InventoryScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Incorrect username or password. Please try again.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      );
    }
  }
}
