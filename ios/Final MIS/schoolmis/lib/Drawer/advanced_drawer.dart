import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class AdvancedDrawerWidget extends StatefulWidget {
  final AdvancedDrawerController controller;

  const AdvancedDrawerWidget(this.controller, {super.key});

  @override
  _AdvancedDrawerWidgetState createState() => _AdvancedDrawerWidgetState();
}

class _AdvancedDrawerWidgetState extends State<AdvancedDrawerWidget> {
  int _selectedIndex = -1; // Track the index of the selected tile

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey, // Background color for the drawer
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          buildTile(0, Icons.home, 'Home'),
          buildTile(1, Icons.favorite, 'Developers'),
          buildTile(2, Icons.contact_mail, 'Contact'),
          buildTile(3, Icons.logout_sharp, 'logout'),
          const Spacer(),
          DefaultTextStyle(
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 245, 245),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              child: const Text('Terms of Service | Privacy Policy'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTile(int index, IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index; // Set the selected index
        });
        // Handle onTap logic here if needed
      },
      child: Container(
        color: _selectedIndex == index
            ? const Color.fromARGB(255, 213, 129, 255).withOpacity(0.8)
            : const Color.fromARGB(255, 255, 143, 143), // Change color on selection
        child: ListTile(
          leading: Icon(icon, color: const Color.fromARGB(255, 0, 0, 0)), // Icon color
          title: Text(
            title,
            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // Text color
          ),
        ),
      ),
    );
  }
}
