import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulBuilder {
  final List<Teachers> teachers = [
    Teachers(
      name: 'Dhanraj ',
      phoneNumber: '',
      // email: 'teacher1@example.com'
    ),
    Teachers(
      name: 'Chandrakant',
      phoneNumber: '',
      // email: 'teacher2@example.com'
    ),
  ];

  ContactScreen();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Teachers Contact',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 20, // Adjust the font size if needed
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate(
              (BuildContext context, int index) {
                return Card(
                  elevation: 10,
                  shadowColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                      height: 2,
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(teachers.name[0]),
                    ),
                    title: Text(teachers[index].name,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text(teachers[index].phoneNumber,
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.call,
                              color: Theme.of(context).primaryColor),
                          onTap: () {
                            _makePhoneCall(teachers.phoneNumber);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.message,
                              color: Theme.of(context).primaryColor),
                          onPressed: () {
                            _sendMessage(teachers.phoneNumber);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to initiate a phone call
  void _makePhoneCall(String phoneNumber) {
    final url = 'tel:phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch url';
    }
  }

  // Function to send an email
  void _sendMessage(String phoneNumber) {
    final url = 'sms:phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch url';
    }
  }
}

class Teachers {
  final String name;
  final String phoneNumber;
  // final String email;

  Teachers(name, phoneNumber);
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
