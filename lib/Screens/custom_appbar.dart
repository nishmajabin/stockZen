import 'package:flutter/material.dart';
import 'package:stockzen/constant.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool? automaticallyImplyLeading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Text(
          title,
        ),
      ),
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      centerTitle: true,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading!,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
