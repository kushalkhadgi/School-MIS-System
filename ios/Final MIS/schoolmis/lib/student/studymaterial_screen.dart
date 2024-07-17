import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:url_launcher/url_launcher.dart';

class StudyMaterialScreen extends StatefulWidget {
  const StudyMaterialScreen({super.key});

  @override
  _StudyMaterialScreenState createState() => _StudyMaterialScreenState();
}

class _StudyMaterialScreenState extends State<StudyMaterialScreen> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  List<String> pdfFileNames = [];

  @override
  void initState() {
    super.initState();
    fetchPDFList();
  }

  Future<void> fetchPDFList() async {
    try {
      firebase_storage.ListResult result =
          await storage.ref('uploads').listAll();

      setState(() {
        pdfFileNames = result.items.map((item) => item.name).toList();
      });
    } catch (e) {
      print('Error fetching PDF list: $e');
    }
  }

  Future<void> downloadAndLaunchPDF(String fileName) async {
    try {
      String downloadURL =
          await storage.ref('uploads/$fileName').getDownloadURL();
      launch(downloadURL);
    } catch (e) {
      print('Error downloading or launching PDF: $e');
    }
  }

  @override
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
          ? const Center(child: Text('No PDF files found.'))
          : ListView.builder(
              itemCount: pdfFileNames.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.picture_as_pdf),
                    title: Text(pdfFileNames[index]),
                    onTap: () => downloadAndLaunchPDF(pdfFileNames[index]),
                  ),
                );
              },
            ),
    );
  }
}
