
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockzen/Screens/profile/edit_profile/edit_profile_screen.dart';
import 'package:stockzen/Screens/privacy_policy_screen.dart';
import 'package:stockzen/Screens/settings_screen.dart';
import 'package:stockzen/Screens/sign_in_screen.dart';
import 'package:stockzen/functions/userdb.dart';
import 'package:stockzen/Screens/inventory/inventory_screen.dart';
import 'package:stockzen/main.dart';
import '../../constant.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  String? email;
  String? pickedImage;

  @override
  void initState() {
    super.initState();
    fetchAndSetUserName();
  }

  Future<void> userLogout() async {
    final sharedpref = await SharedPreferences.getInstance();
    sharedpref.setBool(userLogged, false);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const SignInScreen()));
  }

  Future<void> fetchAndSetUserName() async {
    final user = await fetchUser();
    setState(() {
      userName = user.name.toUpperCase();
      email = user.email.toLowerCase();
      pickedImage = user.image;
    });
  }

  void _showLogoutAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Confirm Logout',
              style:
                  TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
            ),
            content: const Text('Are you sure you want to Logout'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                  )),
              ElevatedButton(
                onPressed: () {
                  userLogout();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          );
        });
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
              secondaryColor,
              Color.fromARGB(255, 199, 215, 230),
              secondaryColor
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                height: 120,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop(MaterialPageRoute(
                              builder: (context) => const InventoryScreen()));
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: primaryColor,
                        ))
                  ],
                ),
              ),
            ),
            Container(
              height: 125,
              width: 125,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.5),
                    spreadRadius: 1.5,
                    blurRadius: 10,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: primaryColor,
                child: pickedImage != null
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: FileImage(File(pickedImage!)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const CircleAvatar(
                        radius: 40,
                        backgroundColor: primaryColor,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 50,
                        )),
              ),
            ),
            const SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  userName ?? 'Loading...',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  email ?? 'Loading...',
                  style: const TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [primaryColor, primaryColor2],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight),
                        borderRadius: BorderRadius.circular(50)),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final value = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                        if (value != null) {
                          setState(() {
                            fetchAndSetUserName();
                          });
                        }
                      },
                      label: const Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Container(
                        alignment: Alignment.bottomLeft,
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Content',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )),
                    SizedBox(
                      width: 420,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsScreen()));
                              },
                              iconColor: primaryColor,
                              textColor: primaryColor,
                              leading: const Icon(Icons.settings),
                              title: const Text('Settings'),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                            const Divider(
                              color: secondaryColor,
                              thickness: 1,
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                    (context),
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PrivacyPolicyScreen()));
                              },
                              iconColor: primaryColor,
                              textColor: primaryColor,
                              leading: const Icon(Icons.privacy_tip),
                              title: const Text('Privacy Policy'),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                            const Divider(
                              color: secondaryColor,
                              thickness: 1,
                            ),
                            const ListTile(
                              iconColor: primaryColor,
                              textColor: primaryColor,
                              leading: Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Icon(
                                  FontAwesomeIcons.solidFileLines,
                                  size: 20,
                                ),
                              ),
                              title: Text('Terms and Conditions'),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                            const Divider(
                              color: secondaryColor,
                              thickness: 1,
                            ),
                            ListTile(
                              onTap: () {
                                _showLogoutAlert();
                              },
                              textColor: primaryColor,
                              leading: const Icon(
                                FontAwesomeIcons.signOut,
                                color: Colors.red,
                              ),
                              title: const Text(
                                'Logout',
                                style: TextStyle(color: Colors.red),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: primaryColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 100),
              child: Text(
                'Version 1.0',
                style: TextStyle(color: Color.fromARGB(255, 52, 99, 130)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
