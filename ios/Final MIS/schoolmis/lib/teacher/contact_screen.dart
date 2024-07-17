import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(titleText: 'Contact Teacher'),
    ); //appbar
  }
}
