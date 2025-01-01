import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stockzen/Screens/profile/profile_screen.dart';
import 'package:stockzen/constant.dart';

class CustomHeader extends StatelessWidget {
  final String? pickedImage;
  final Function? fetchUserImage;

  const CustomHeader({
    super.key,
    this.pickedImage,
    this.fetchUserImage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 126,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'stockZen',
                style: TextStyle(
                  fontFamily: 'Rakkas',
                  color: Colors.white,
                  fontSize: 48,
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: CircleAvatar(
                      radius: 21,
                      backgroundColor: Colors.white,
                      child: pickedImage != null
                          ? GestureDetector(
                              onTap: () async {
                                final value = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => const ProfileScreen(),
                                  ),
                                );
                                if (value != null && fetchUserImage != null) {
                                  fetchUserImage!();
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: FileImage(File(pickedImage!)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => const ProfileScreen(),
                                  ),
                                );
                              },
                              child: const CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  color: primaryColor,
                                  size: 28,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
