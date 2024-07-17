import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const BackgroundWidget({super.key, required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/body.jpg'), fit: BoxFit.fill)),
      child: child,
    );
  }
}
