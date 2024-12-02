 import 'package:flutter/material.dart';

Widget buildCustomRow({
    required BuildContext context,
    required title,
    required Widget navigateTo,
    Color titleColor = Colors.white,
    Color linkColor = Colors.white,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => navigateTo,
                  ));
            },
            child: Text(
              'More...',
              style: TextStyle(color: linkColor),
            ),
          ),
        )
      ],
    );
  }
   