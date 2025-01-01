import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockzen/constant.dart';

class SourceChoiceDialog extends StatelessWidget {
  final Function(ImageSource) onSourceSelected;

  const SourceChoiceDialog({super.key, required this.onSourceSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actions: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  iconColor: primaryColor,
                  textColor: primaryColor,
                  onTap: () {
                    Navigator.of(context).pop();
                    onSourceSelected(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  iconColor: primaryColor,
                  textColor: primaryColor,
                  onTap: () {
                    Navigator.of(context).pop();
                    onSourceSelected(ImageSource.gallery);
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Tap to Choose Source',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
