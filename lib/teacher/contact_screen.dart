import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class ContactScreen extends StatefulBuilder {
  const ContactScreen();

  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(titleText: 'Contact Teacher'),
    ); //appbar
  }
}
