import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;

  const CustomAppBar({required this.titleText});

  @override
  Widget build(BuildContext context) {
    iconTheme: const IconThemeData(color: Colors.red);
    return NavBar(
      title: Text(
        titleText,
        style: const TextStyle(
          shadows: <Shadow>[
            Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 8.0,
              color: Color.fromARGB(125, 0, 0, 255),
            ),
          ],
        ),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      backgroundColor: Colors.deepPurpleAccent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
