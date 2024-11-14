// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/userdb.dart';
import 'package:stockzen/Screens/inventory_screen.dart';
import 'package:stockzen/main.dart';
import 'package:stockzen/models/usermodel.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool hidePd = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> userAccess() async {
    final sharedpref = await SharedPreferences.getInstance();
    sharedpref.setBool(userLogged, true);

    final user = UserModel(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        image: null);
        
    addUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: secondColor,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 200),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: primaryColor),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 325),
                child: Center(
                  child: Container(
                    width: 380,
                    height: 680,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, primaryColor2],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(27),
                            topRight: Radius.circular(27))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 350),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 640,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              secondaryColor,
                              Color.fromARGB(255, 199, 215, 230),
                              secondaryColor
                            ],
                            stops: [
                              0.0,
                              0.5,
                              1.0
                            ]),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(27),
                            topRight: Radius.circular(27))),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 450),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: nameController,
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
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                              if (!emailRegex.hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.mail,
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
                              labelText: 'Email',
                              labelStyle: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: passwordController,
                            obscureText: hidePd,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Password must be at least 6 characters long';
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
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hidePd = !hidePd;
                                    });
                                  },
                                  icon: hidePd
                                      ? const FaIcon(
                                          FontAwesomeIcons.eyeSlash,
                                          size: 19,
                                          color: primaryColor,
                                        )
                                      : const Icon(
                                          Icons.remove_red_eye_outlined,
                                          color: primaryColor,
                                        )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Center(
                          child: Container(
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
                            if (_formKey.currentState!.validate()) {
                              userAccess();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const InventoryScreen()),
                              );
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 60, vertical: 13),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
