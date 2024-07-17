import 'package:flutter/material.dart';

class DashboardItem extends StatefulWidget {
  final String imagePath;

  const DashboardItem());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 50)]),
        child: Padding(
          padding: const EdgeInsets,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                imagePath,
                width: 30,
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
