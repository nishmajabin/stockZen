import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockzen/constant.dart';
import 'package:stockzen/functions/brand_db.dart';
import 'package:stockzen/models/brand_model.dart';

class AddBrandScreen extends StatefulWidget {
  const AddBrandScreen({super.key});

  @override
  State<AddBrandScreen> createState() => _AddBrandScreenState();
}

class _AddBrandScreenState extends State<AddBrandScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _brandNameController = TextEditingController();
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

  Future<void> saveBrand() async {
    final id = DateTime.now().microsecond.toString();
    final brand = BrandModel(
        id: id, name: _brandNameController.text, imagePath: _pickedImage!.path);
    BrandDb().addBrand(brand);
    Navigator.pop(context, 1);
  }

  void showImageSourceBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Wrap(
            children: <Widget>[
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
              )
            ],
          ));
        });
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
              'Add Brand',
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
            const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 5),
                  child: Text(
                    'Brand name:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 8),
              child: TextFormField(
                controller: _brandNameController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: primaryColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            const BorderSide(width: 1, color: primaryColor)),
                    hintText: 'Enter Brand name',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 136, 136, 136)),
                    filled: true,
                    fillColor: const Color.fromARGB(128, 206, 206, 206)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the brand name';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 5),
                  child: Text(
                    'Brand Image:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
              child: GestureDetector(
                onTap: showImageSourceBottomSheet,
                child: Container(
                  width: double.infinity,
                  height: 130,
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor),
                    borderRadius: BorderRadius.circular(5),
                    color: const Color.fromARGB(128, 206, 206, 206),
                  ),
                  child: _pickedImage != null
                      ? Image.file(_pickedImage!, fit: BoxFit.cover)
                      : const Icon(
                          Icons.image,
                          size: 35,
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 20, left: 40, right: 40),
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [primaryColor, primaryColor2],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                      borderRadius: BorderRadius.circular(50)),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _pickedImage != null) {
                        saveBrand();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Please Add image as well.',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            duration: const Duration(seconds: 2),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        );
                      }
                    },
                    label: const Text(
                      'Save Brand',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
