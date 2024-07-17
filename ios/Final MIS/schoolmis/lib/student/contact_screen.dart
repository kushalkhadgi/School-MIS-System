import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  final List<Teachers> teachers = [
    Teachers(
      name: 'Dhanraj Rahulkar',
      phoneNumber: '+91 9284841506',
      // email: 'teacher1@example.com'
    ),
    Teachers(
      name: 'Chandrakant Masurkar',
      phoneNumber: '+91 93563 04607',
      // email: 'teacher2@example.com'
    ),
    // Teachers(
    //   name: 'Teacher 3',
    //   phoneNumber: '555-555-5555',
    //   // email: 'teacher3@example.com'
    // ),
  ];

  ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Teachers Contact',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 20, // Adjust the font size if needed
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Card(
                  elevation: 10,
                  shadowColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(teachers[index].name[0]),
                    ),
                    title: Text(teachers[index].name,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text(teachers[index].phoneNumber,
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.call,
                              color: Theme.of(context).primaryColor),
                          onPressed: () {
                            _makePhoneCall(teachers[index].phoneNumber);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.message,
                              color: Theme.of(context).primaryColor),
                          onPressed: () {
                            _sendMessage(teachers[index].phoneNumber);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: teachers.length,
            ),
          ),
        ],
      ),
    );
  }

  // Function to initiate a phone call
  void _makePhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to send an email
  void _sendMessage(String phoneNumber) async {
    final url = 'sms:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class Teachers {
  final String name;
  final String phoneNumber;
  // final String email;

  Teachers({required this.name, required this.phoneNumber});
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.red,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: ContactScreen(),
  ));
}
