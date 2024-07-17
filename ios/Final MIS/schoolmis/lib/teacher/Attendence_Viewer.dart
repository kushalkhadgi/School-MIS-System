import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class AttendanceViewer extends StatelessWidget {
  const AttendanceViewer({super.key});

  @override
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
        future: _getPDFList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
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
  final List<String> pdfList = [];

  try {
    final firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref('Attendance/')
        .list();

    // Fetch metadata for each item
    final List<firebase_storage.FullMetadata> metadataList = await Future.wait(
      result.items.map((item) => item.getMetadata()),
    );

    // Create a list of Map entries with the filename and timeCreated
    final List<MapEntry<String, DateTime>> sortedEntries = List.generate(
      result.items.length,
      (index) => MapEntry(
        result.items[index].name,
        metadataList[index].timeCreated!,
      ),
    );

    // Sort the list based on timeCreated in descending order
    sortedEntries.sort((a, b) => b.value.compareTo(a.value));

    // Extract the sorted filenames
    final List<String> sortedFilenames =
        sortedEntries.map((entry) => entry.key).toList();

    pdfList.addAll(sortedFilenames);
  } catch (e) {
    print('Error fetching PDF list: $e');
  }

  return pdfList;
}





  void _launchPDF(String pdfName) async {
    final String? filePath = await _downloadPDF(pdfName);

    if (filePath != null) {
      OpenFile.open(filePath);
    } else {
      print('Could not open the PDF');
    }
  }

  Future<String?> _downloadPDF(String pdfName) async {
    try {
      final String localPath = (await getTemporaryDirectory()).path;
      final File pdfFile = File('$localPath/$pdfName');

      await firebase_storage.FirebaseStorage.instance
          .ref('Attendance/$pdfName')
          .writeToFile(pdfFile);

      return pdfFile.path;
    } catch (e) {
      print('Error downloading PDF: $e');
      return null;
    }
  }
}
