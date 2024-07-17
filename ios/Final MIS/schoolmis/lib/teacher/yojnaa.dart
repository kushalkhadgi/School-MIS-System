import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherYojnaaScreen extends StatefulWidget {
  const TeacherYojnaaScreen({super.key});

  @override
  _TeacherYojnaaScreenState createState() => _TeacherYojnaaScreenState();
}

class _TeacherYojnaaScreenState extends State<TeacherYojnaaScreen> {
  final TextEditingController _schemeNameController = TextEditingController();
  final TextEditingController _schemeLinkController = TextEditingController();
  final TextEditingController _schemeDescriptionController = TextEditingController();

  void _submitScheme() async {
    String schemeName = _schemeNameController.text;
    String schemeLink = _schemeLinkController.text;
    String schemeDescription = _schemeDescriptionController.text;

    if (schemeName.isNotEmpty && schemeLink.isNotEmpty) {
      await FirebaseFirestore.instance.collection('schemes').add({
        'name': schemeName,
        'link': schemeLink,
        'description': schemeDescription,
      });

      _schemeNameController.clear();
      _schemeLinkController.clear();
      _schemeDescriptionController.clear();
      // Show a success message or navigate to a success page if needed
    } else {
      // Show an error message
    }
  }

  void _deleteScheme(String schemeId) async {
    await FirebaseFirestore.instance.collection('schemes').doc(schemeId).delete();
  }





  void _showAddSchemeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Yojnaa Scheme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _schemeNameController,
                decoration: const InputDecoration(labelText: 'Scheme Name'),
              ),
              TextField(
                controller: _schemeLinkController,
                decoration: const InputDecoration(labelText: 'Scheme Link'),
              ),
              TextField(
                controller: _schemeDescriptionController,
                decoration: const InputDecoration(labelText: 'Scheme Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _submitScheme();
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload Yojnaa',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddSchemeDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('schemes').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            final docs = snapshot.data?.docs;
            if (docs == null) return const CircularProgressIndicator();
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = docs[index];
                return Card(
                  elevation: 2.0,
                  child: ListTile(
                    title: Text(
                      doc['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(doc['description']),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(doc['name']),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: [
                                      const TextSpan(
                                        text: 'Description: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, // Making it bold
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${doc['description']}',
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (await canLaunch(doc['link'])) {
                                      await launch(doc['link']);
                                    } else {
                                      // Handle the error
                                    }
                                  },
                                  

                                  child: RichText(
                                     text: TextSpan(
                                       style: DefaultTextStyle.of(context).style,
                                       children: [
                                         const TextSpan(
                                           text: 'Link : ',
                                           style: TextStyle(
                                             color: Colors.black,
                                             
                                            fontWeight: FontWeight.bold,
                                           ),
                                         ),
                                         TextSpan(
                                           text: doc['link'],
                                           style: const TextStyle(color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                            decorationColor: Colors.blue),
                                         ),
                                       ],
                                     ),
                                   ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _deleteScheme(doc.id); // Delete the scheme when the button is pressed
                                  Navigator.of(context).pop(); // Close the AlertDialog
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
