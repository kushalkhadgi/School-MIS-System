import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetail {
  final String description;
  final String action;

}

class ContactPage extends StatefulBuilder {
  const ContactPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 20, // Adjust the font size if needed
          ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              child: buildContactCard(
                'For any kind of query \ncontact between 9:00 a.m to 5:00 p.m.',
                Icons.mail,
                [
                  ContactDetail(
                      'dev.it@svpcet.com', 'mailto:dev.it@svpcet.com'),
                  ContactDetail(
                      'dev.23.it@svpcet.com', 'mailto:dev.23.it@svpcet.com'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Hero(
              child: buildContactCard(
                'Phone',
                Icons.phone,
                [
                  ContactDetail('Developer 1: 9356304607', 'tel:9356304607'),
                  ContactDetail('Developer 2: 9356304605', 'tel:9356304605'),
                  ContactDetail('Developer 3: 9356304607', 'tel:9356304607'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/drawer/dev.png', // Replace with your image asset path
              fit: BoxFit.cover, // Adjust the fit as needed
              height: 350, // Set the height as needed
              width: double.infinity, // Occupy full width
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContactCard(
      String title, List<ContactDetail> details) {
    return Card(
      elevation: 4.0,
      shadowColor: Colors.grey.withOpacity(0.5), // Set shadow color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 230, 193, 255),
              Color.fromARGB(255, 255, 253, 202),
            ], // Replace with your gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 1.0], // Add gradient stops
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: details
                    .map(
                      (detail) => Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0), // Add space between items
                        child: InkWell(
                          onTap: () async {
                            if (await canLaunch(detail.action)) {
                              await launch(detail.action);
                            } else {
                              throw 'Could not launch ${detail.action}';
                            }
                          },
                        ),
                      ),
                    )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
