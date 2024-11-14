import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/userdb.dart';
import 'package:stockzen/models/usermodel.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _editUserNameController;
  late TextEditingController _editUserEmailController;
  late TextEditingController _editUserPdController;
  File? _pickedImage;
  String? image;
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  void _showSourceChoice() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                iconColor: primaryColor,
                textColor: primaryColor,
                onTap: () {
                  Navigator.of(context).pop();
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                iconColor: primaryColor,
                textColor: primaryColor,
                onTap: () {
                  Navigator.of(context).pop();
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _editUserNameController = TextEditingController();
    _editUserEmailController = TextEditingController();
    _editUserPdController = TextEditingController();

    fetchAndSetUserName();
  }

  Future<void> fetchAndSetUserName() async {
    final editUser = await fetchUser();
    setState(() {
      _editUserNameController.text = editUser.name;
      _editUserEmailController.text = editUser.email;
      _editUserPdController.text = editUser.password;
      image = editUser.image;
  
    });
  }

  Future<void> updatedUser() async {
    final editedUser = UserModel(
        name: _editUserNameController.text,
        email: _editUserEmailController.text,
        password: _editUserPdController.text,
        image: _pickedImage!.path );
    updateUser(editedUser);
  }

  @override
  void dispose() {
    _editUserNameController.dispose();
    _editUserEmailController.dispose();
    _editUserPdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [primaryColor, primaryColor2],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight)),
          child: AppBar(
            title: const Text(
              'Edit Profile',
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            Stack(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _showSourceChoice,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryColor, width: 1.3)),
                      child:CircleAvatar(
  radius: 60,
  foregroundColor: primaryColor,
  backgroundColor: const Color.fromARGB(164, 145, 171, 194),
  child: _pickedImage != null
      ? Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: FileImage(_pickedImage!),
              fit: BoxFit.cover,
            ),
          ),
        )
      : (image != null
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: FileImage(File(image!)),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : const Icon(
              Icons.person,
              size: 55,
              color: primaryColor,
            )),
),

                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 90, top: 82),
                    child: GestureDetector(
                      onTap: _showSourceChoice,
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
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _editUserNameController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person_outlined,
                      size: 25,
                      color: primaryColor,
                    ),
                    hintText: 'Change name',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 98, 103, 108)),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _editUserEmailController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.mail_outlined,
                      size: 25,
                      color: primaryColor,
                    ),
                    hintText: 'Enter email',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 98, 103, 108)),
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
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _editUserPdController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      size: 25,
                      color: primaryColor,
                    ),
                    hintText: 'Change Password',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 98, 103, 108)),
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
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
                width: 200,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [primaryColor, primaryColor2],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight),
                    borderRadius: BorderRadius.circular(50)),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      updatedUser();
                      Navigator.pop(context, 1);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent),
                  child: const Text(
                    'Update Profile',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
