import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockzen/constant.dart';

class CustomImagePicker extends StatefulWidget {
  @override
  _CustomImagePickerState createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  File? _pickedImage;

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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: GestureDetector(
        onTap: _showSourceChoice,
        child: Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            borderRadius: BorderRadius.circular(5),
            color: const Color.fromARGB(128, 206, 206, 206),
          ),
          child: _pickedImage != null
              ? Image.file(_pickedImage!, fit: BoxFit.cover)
              : const Icon(
                  Icons.add_a_photo,
                  size: 40,
                ),
        ),
      ),
    );
  }
}
