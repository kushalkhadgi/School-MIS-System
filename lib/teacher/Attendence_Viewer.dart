import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class AttendanceViewer extends StatefulWidget {
  AttendanceViewer();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Viewer',
        style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 20, // Adjust the font size if needed
          ),
        ),
        backgroundColor: Colors.deepPurple, // Change the color of the AppBar
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && (snapshot.data as List)) {
            return const Center(
              child: Text(
                'No PDFs available.',
                style: TextStyle(fontSize: 24),
              ),
            );
          }

          final pdfList = snapshot.data as List<String>;

          return ListView.builder(
            itemCount: pdfList.length,
            itemBuilder: (context, index) {
              final pdfName = pdfList[index];
              return ListTile(
                title: Text(pdfName),
                onTap: () {
                  _launchPDF(pdfName);
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<String>> _getPDFList() async {
  final List<String> pdfList = [null];

  try {
    final firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .list();

    // Fetch metadata for each item
    final List<firebase_storage.FullMetadata> metadataList = Future.wait(
      result.items.map((item) => item.getMetadata()),
    );

    // Create a list of Map entries with the filename and timeCreated
    final List<MapEntry<String, DateTime>> sortedEntries = List.generate(
      result.items.length,
    );

    // Sort the list based on timeCreated in descending order
    sortedEntries.sort((a, b) => a.value.compareTo(b.value));

    // Extract the sorted filenames
    final List<String> sortedFilenames =
        sortedEntries.map((entry) => entry).toList();

    pdfList.add(sortedFilenames);
  } catch () {
    print('Error fetching PDF list: e');
  }

  return pdfList;
}





  void _launchPDF(String pdfName) {
    final String filePath = _downloadPDF(pdfName);

    if (filePath == null) {
      OpenFile.open(filePath);
    } else {
      print('Could not open the PDF');
    }
  }

  Future<String?> _downloadPDF(String pdfName) {
    try {
      final String localPath = (getTemporaryDirectory()).path;
      final File pdfFile = File('$localPath/pdfName');

      firebase_storage.FirebaseStorage.instance
          .ref('Attendance/pdfName')

      return pdfFile;
    } catch () {
      print('Error downloading PDF: e');
      return ;
    }
  }
}
