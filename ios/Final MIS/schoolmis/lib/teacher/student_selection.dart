import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class StudentSelectionScreen extends StatefulWidget {
  final String selectedGrade;

  StudentSelectionScreen({required this.selectedGrade});

  @override
  _StudentSelectionScreenState createState() => _StudentSelectionScreenState();
}

class _StudentSelectionScreenState extends State<StudentSelectionScreen> {
  List<String> selectedStudents = [];
  List<String> allStudents = [];
  bool selectAll = false;
  late BuildContext _storedContext; // Added variable to store context

  @override
  void initState() {
    super.initState();
    _storedContext = context; // Initialize _storedContext here
    fetchAllStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Selection',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select All',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Checkbox(
                  value: selectAll,
                  onChanged: (bool? value) {
                    setState(() {
                      selectAll = value!;
                      if (selectAll) {
                        selectedStudents = List.from(allStudents);
                      } else {
                        selectedStudents.clear();
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('grade', isEqualTo: widget.selectedGrade)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      'Loading...',
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }

                final students = snapshot.data!.docs;

                if (students.isEmpty) {
                  return Center(
                    child: Text(
                      'No students available for the selected grade.',
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }

                // Update allStudents list
                allStudents = students.map((student) {
                  final data = student.data() as Map<String, dynamic>;
                  return data.containsKey('name') ? data['name'] as String : '';
                }).toList();

                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final studentData =
                        students[index].data() as Map<String, dynamic>;
                    final studentName = studentData['name'];

                    return ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              studentName ?? "",
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Checkbox(
                            value: selectedStudents.contains(studentName),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedStudents.add(studentName!);
                                } else {
                                  selectedStudents.remove(studentName);
                                }
                                selectAll = selectedStudents.length ==
                                    allStudents.length;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Center(
              // Center the button
              child: ElevatedButton(
                onPressed: () async {
                  await _generatePDF(selectedStudents);
                },
                child: Text('Generate Attendance'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fetchAllStudents() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('grade', isEqualTo: widget.selectedGrade)
          .get();

      setState(() {
        allStudents = snapshot.docs
            .map((doc) =>
                doc.data() as Map<String, dynamic>) // Explicitly cast to Map
            .where((data) =>
                data.containsKey('name')) // Check if 'name' field exists
            .map((data) => data['name'] as String) // Access 'name' field
            .where((name) => name.isNotEmpty) // Filter out empty names
            .toList();
      });
    } catch (e) {
      print("Error fetching students: $e");
      // Handle error here
    }
  }

  Future<String> getRollNumberForStudent(String studentName) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isEqualTo: studentName)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs[0].data() as Map<String, dynamic>;
        final rollNo = data['rollno'] as String?;
        return rollNo ?? 'Roll No. not found';
      }
      return 'Roll No. not found';
    } catch (e) {
      print("Error getting roll number: $e");
      return 'Roll No. not found';
    }
  }

  Future<void> _generatePDF(List<String> selectedStudents) async {
    print('Generating PDF...');
    print('Selected Students: $selectedStudents');

    final List<Map<String, dynamic>> studentDataList =
        await Future.wait(selectedStudents.map((studentName) async {
      final rollNo = await getRollNumberForStudent(studentName);
      return {
        'name': studentName,
        'rollno': rollNo,
      };
    }));

    final pdf = await _generateDocument(studentDataList);

    final directory = await getApplicationDocumentsDirectory();
    final String formattedDateTime =
        DateFormat('dd-MM-yy  HH:mm:ss').format(DateTime.now());
    final String fileName =
        'Attendance Class-${widget.selectedGrade}  $formattedDateTime.pdf';

    final String filePath = '${directory.path}/$fileName';
    await File(filePath).writeAsBytes(await pdf.save());

    final firebase_storage.Reference storageReference =
        firebase_storage.FirebaseStorage.instance.ref('Attendance/$fileName');
    final firebase_storage.UploadTask uploadTask =
        storageReference.putFile(File(filePath));

    await uploadTask.whenComplete(() async {
      print('PDF uploaded to Firebase Storage');

      showDialog(
        context: _storedContext,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        barrierDismissible: false,
      );

      // Get the download URL
      final String downloadURL = await storageReference.getDownloadURL();

      try {
        ScaffoldMessenger.of(_storedContext).showSnackBar(
          // Used stored context here
          SnackBar(
            content: Text('Attendance generated successfully!'),
            action: SnackBarAction(
              label: 'View PDF',
              onPressed: () {
                // Launch PDF with the file name
                _launchPDF(_storedContext,
                    fileName); // Pass stored context and fileName
              },
            ),
          ),
        );
      } catch (error) {
        print('Error generating PDF: $error');
        ScaffoldMessenger.of(_storedContext).showSnackBar(
          // Used stored context here
          SnackBar(
            content: Text('Error generating attendance. Please try again.'),
          ),
        );
      } finally {
        // Hide loading indicator
        Navigator.of(_storedContext).pop();
      }

      Navigator.pop(_storedContext); // Navigate back to the attendance screen
    }).catchError((error) {
      print('Error uploading PDF: $error');
      ScaffoldMessenger.of(_storedContext).showSnackBar(
        // Used stored context here
        SnackBar(
          content: Text('Error generating attendance. Please try again.'),
        ),
      );
    });
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

  void _launchPDF(BuildContext context, String pdfName) async {
    final String? filePath = await _downloadPDF(pdfName);

    if (filePath != null) {
      OpenFile.open(filePath);
    } else {
      print('Could not open the PDF');
    }
  }

  Future<pw.Document> _generateDocument(
      List<Map<String, dynamic>> selectedStudents) async {
    final doc = pw.Document();

    String formattedDate =
        DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());

    doc.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(
                height: 20,
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'St. Vincent Pallotti College of Engineering',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Attendance Report',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
              pw.SizedBox(
                height: 20,
              ),
              pw.Row(
                children: [
                  pw.Text(
                    'Date: $formattedDate',
                    style: pw.TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(
                height: 20,
              ),
              pw.Text(
                'Attendance Table',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(
                height: 10,
              ),
              pw.Table.fromTextArray(
                headerDecoration:
                    pw.BoxDecoration(color: PdfColor.fromInt(0xFFCCCCCC)),
                headerHeight: 25,
                cellHeight: 30,
                cellAlignment: pw.Alignment.centerLeft,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: ['Roll Number', 'Name'],
                data: List<List<String>>.generate(
                  selectedStudents.length,
                  (index) {
                    final rollno =
                        selectedStudents[index]['rollno']?.toString() ?? '';
                    final name =
                        selectedStudents[index]['name']?.toString() ?? '';

                    // Debug prints
                    print('Roll Number: $rollno, Name: $name');
                    print('Selected Students: $selectedStudents');
                    return [rollno, name]; // Reversed order to match headers
                  },
                ),
              ),
              pw.SizedBox(
                height: 20,
              ),
            ],
          );
        },
      ),
    );

    return doc;
  }
}

// Placeholder for the PDF viewer screen. Replace it with your actual implementation.
class YourPdfViewerScreen extends StatelessWidget {
  final String? pdfFilePath;

  const YourPdfViewerScreen({required this.pdfFilePath});

  @override
  Widget build(BuildContext context) {
    // Implement your PDF viewer screen here
    // Use the pdfFilePath to load and display the PDF
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Center(
        child: Text('Implement your PDF viewer here'),
      ),
    );
  }
}
