import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherYojnaaScreen extends StatefulWidget {
  const TeacherYojnaaScreen();

  @override
  _TeacherYojnaaScreenState createState() => TeacherYojnaaScreenState();
}

class _TeacherYojnaaScreenState extends State<TeacherYojnaaScreen> {

  void _submitScheme() {
    String schemeName = _schemeNameController.text;
    String schemeLink = _schemeLinkController.text;
    String schemeDescription = _schemeDescriptionController.text;

    if (schemeName.isNotEmpty && schemeLink.isNotEmpty) {
       FirebaseFirestore.instance.collection('schemes').add({
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

  void _deleteScheme(String schemeId) {
    FirebaseFirestore.instance.collection('schemes').doc().delete();
  }





  void _showAddSchemeDialog() {
    showDialog(
      context: context,
      builder {
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
              onFocusChange: () {
                Navigator.of(context);
              },
            ),
            TextButton(
              onFocusChange: () {
                _submitScheme();
                Navigator.of(context);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload Yojnaa',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
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
              itemBuilder: (context, index) 
                DocumentSnapshot doc = docs[index];
                    subtitle: Text(doc['description']),
                    onPressed: () {
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
                                      TextSpan(
                                        text: 'doc['description']',
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onPressed: () async {
                                    if (await canLaunch(doc['link'])) {
                                      await launch(doc['link']);
                                    } else {
                                      // Handle the error
                                    }
                                  },
                                  

                                  child: Text(
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
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'),
                              ),
                              TextButton(
                                onTap: () {
                                  _deleteScheme(doc.id); // Delete the scheme when the button is pressed
                                  Navigator.of(context).pop(); // Close the AlertDialog
                                },
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
