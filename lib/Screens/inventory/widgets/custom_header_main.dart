import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stockzen/screens/profile/profile_screen.dart';
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
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            secondaryColor,
            Color.fromARGB(239, 186, 209, 229),
            secondaryColor
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 90, 121, 149).withOpacity(0.5),
            blurRadius: 1.5,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'stockZen',
                style: TextStyle(
                  fontFamily: 'Rakkas',
                  color: primaryColor,
                  fontSize: 48,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: GestureDetector(
                  onTap: () async {
                    if (pickedImage != null) {
                      final value = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const ProfileScreen(),
                        ),
                      );
                      if (value != null && fetchUserImage != null) {
                        fetchUserImage!();
                      }
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const ProfileScreen(),
                        ),
                      );
                    }
                  },
                  child: CircleAvatar(
                    radius: 21,
                    backgroundColor: Colors.white,
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
                            radius: 20,
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
        ),
      ),
    );
  }
}
