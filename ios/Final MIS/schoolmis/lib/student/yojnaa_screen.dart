import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

class StudentYojnaaScreen extends StatelessWidget {
  const StudentYojnaaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Yojnaa Screen',
        style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 20, // Adjust the font size if needed
          ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('schemes').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No schemes available.'),
            );
          }

          var schemes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: schemes.length,
            itemBuilder: (context, index) {
              var scheme = schemes[index];
              return Card(
                elevation: 5,
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(scheme['name']),
                      GestureDetector(
                        onTap: () {
                          _showSchemeDetails(context, scheme);
                        },
                        child: const Text(
                          '',//Can add view button to the right of the tile
                          style: TextStyle(
                            color: Colors
                                .blue, // You can set your desired text color
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    _showSchemeDetails(context, scheme);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showSchemeDetails(BuildContext context, QueryDocumentSnapshot scheme) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SchemeDetailsScreen(scheme),
      ),
    );
  }
}

class SchemeDetailsScreen extends StatelessWidget {
  final QueryDocumentSnapshot scheme;

  const SchemeDetailsScreen(this.scheme, {super.key});

  void _launchURL() async {
    final String url = scheme['link'];
    FlutterWebBrowser.openWebPage(
      url: url,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(scheme['name'],
        style: const TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 20, // Adjust the font size if needed
          ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple,
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scheme Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(scheme['description']),
            ),
            const SizedBox(height: 16),
            const Text(
              'Scheme URL:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _launchURL,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  scheme['link'],
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
