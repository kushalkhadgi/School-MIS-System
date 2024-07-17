import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final EdgeInsets padding;
  const BackgroundWidget({super.key, required padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/body.jpg'), fit: BoxFit.auto)),
    );
  }
}
