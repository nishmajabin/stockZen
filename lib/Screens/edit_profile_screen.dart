import 'package:flutter/material.dart';
import 'package:stockzen/constant.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

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
              'Edit Profile',
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 70,
          ),
          Stack(
            children: [
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(164, 145, 171, 194),
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryColor, width: 1.3),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 55,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 90, top: 82),
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: primaryColor),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 35),
            child: TextFormField(
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person_outlined,
                    size: 25,
                    color: primaryColor,
                  ),
                  hintText: 'Change name',
                  hintStyle:
                      const TextStyle(color: Color.fromARGB(255, 98, 103, 108)),
                  labelText: 'Name',
                  labelStyle: const TextStyle(color: primaryColor),
                  filled: true,
                  fillColor: const Color.fromARGB(128, 206, 206, 206),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 1.2,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.4))),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 35),
            child: TextFormField(
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.mail_outlined,
                    size: 25,
                    color: primaryColor,
                  ),
                  hintText: 'Enter email',
                  hintStyle:
                      const TextStyle(color: Color.fromARGB(255, 98, 103, 108)),
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: primaryColor),
                  filled: true,
                  fillColor: const Color.fromARGB(128, 206, 206, 206),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 1.2,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.4))),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 35),
            child: TextFormField(
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    size: 25,
                    color: primaryColor,
                  ),
                  hintText: 'Change Password',
                  hintStyle:
                      const TextStyle(color: Color.fromARGB(255, 98, 103, 108)),
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: primaryColor),
                  filled: true,
                  fillColor: const Color.fromARGB(128, 206, 206, 206),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 1.2,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.4))),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
              width: 200,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [primaryColor, primaryColor2],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight),
                  borderRadius: BorderRadius.circular(50)),
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Update Profile',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent),
              )),
        ],
      ),
    );
  }
}
