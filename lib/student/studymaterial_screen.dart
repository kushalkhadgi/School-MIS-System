import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:url_launcher/url_launcher.dart';

class StudyMaterialScreen extends StatefulWidget {
  const StudyMaterialScreen();

  _StudyMaterialScreenState createState() => _StudyMaterialScreenState();
}

class _StudyMaterialScreenState extends State<StudyMaterialScreen> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  List<String> pdfFileNames = [];

  void initState() {
    final initState();
  }

  Future<void> fetchPDFList() {
    try {
      firebase_storage.ListResult result =
          storage.ref('uploads');

      setState(() {
        pdfFileNames = result.items.map(item.name);
      });
    } catch () {
      print('Error fetching PDF list: e');
    }
  }

  Future<void> downloadAndLaunchPDF(String fileName) {
    try {
      String downloadURL =
          storage.ref('uploads/fileName').getDownloadURL();
      launch(downloadURL);
    } catch () {
      print('Error downloading or launching PDF: e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Material Screen',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 20, // Adjust the font size if needed
          ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple),
      body: pdfFileNames.isEmpty
            const Center(child: Text('No PDF files found.'))
          : ListView.builder(
              itemCount: pdfFileNames.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.picture_as_pdf),
                    title: Text(pdfFileNames[index]),
                    onPressed: () => downloadAndLaunchPDF(pdfFileNames[index]),
                  ),
                );
              },
            ),
    );
  }
}
