import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:schoolmis/teacher/studentprofile.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:io';

class StudentDetailScreen extends StatelessWidget {
  const StudentDetailScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const StudentList(),
    );
  }
}

class StudentList extends StatefulWidget {
  const StudentList();

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  String selectedClass = '1'; // Default selected class

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text(
              'Loading...',
              style: TextStyle(fontSize: 24),
            ),
          );
        }

        final students = snapshot.data!.docs;

        // Filter students by grade
        final Map<String, List<Map<String, dynamic>>> studentsByGrade = {};
        for (var doc in students) {
          final studentData = doc.data() as Map<String, dynamic>;
          final role = studentData['role'];
          final grade = studentData['grade'];

          if (role == 'student' && grade.isNotEmpty) {
            studentsByGrade.putIfAbsent(grade, () => []);
            studentsByGrade[grade]!.add(studentData);
          }
        }

        if (studentsByGrade.isEmpty) {
          return const Center(
            child: Text(
              'No students available.',
              style: TextStyle(fontSize: 24),
            ),
          );
        }

        // Sort grades in ascending order
        final sortedGrades = studentsByGrade.keys.toList()
          ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

        return Column(
          children: [
            DropdownButton<String>(
              value: selectedClass,
              onChanged: (String? newValue) {
                setState(() {
                  selectedClass = newValue!;
                });
              },
              items: sortedGrades.map<DropdownMenuItem<String>>((String grade) {
                return DropdownMenuItem<String>(
                  value: grade,
                  child: Text('Class $grade'),
                );
              }).toList(),
            ),
            Expanded(
              child: ListView(
                children: studentsByGrade[selectedClass]!.map((studentData) {
                  final studentName = studentData['name'];

                  return ListTile(
                    title: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(studentName: studentName),
                          ),
                        );
                      },
                      child: Text(
                        studentName ?? "",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final filePath = await _exportToExcel(studentsByGrade[selectedClass]!, selectedClass);
                  _showSnackBar(context, filePath);
                },
                child: const Text('Export to Excel'),
              ),
            ),
          ],
        );
      },
    );
  }
  Future<String> _exportToExcel(List<Map<String, dynamic>> students, selectedClass) async {
  final Excel excel = Excel.createExcel();
  final Sheet sheet = excel[excel.getDefaultSheet() ?? 'Sheet1'];

  sheet.appendRow([
    'Name',
    'Email',
    'Phone Number',
    'Grade',
    'Age',
    'Address',
    'Gender',
    'DateOfBirth',
    "Father's name",
    "Mother's name",
    "Parent's email",
    'Aadhaar number',
    'Caste',
    'Blood group',
    'Date of Admission'
  ]);

  for (int i = 0; i < students.length; i++) {
    final student = students[i];
    sheet.appendRow([
      student['name'],
      student['email'],
      student['mobilenumber'],
      student['grade'],
      student['age'],
      student['address'],
      student['gender'],
      student['dob'],
      student['fathername'],
      student['mothername'],
      student['parentemail'],
      student['adhar'],
      student['caste'],
      student['bloodgroup'],
      student['dateofadmission']
    ]);
  }

  final bytes = excel.encode();
  final directory = await path_provider.getExternalStorageDirectory();
  final path = directory?.path;
  final fileName = 'Class_$selectedClass-students_${DateTime.now().toString()}.xlsx';
  final file = File('$path/$fileName');
  await file.writeAsBytes(bytes!);
  final filePath = file.path;

  log('Excel file saved at: $filePath');

  return filePath;
  }

  void _showSnackBar(BuildContext context, String filePath) {
    final snackBar = SnackBar(
      content: Text('Excel Sheet Generated Successfully'),
      action: SnackBarAction(
        label: 'Open',
        onPressed: () async {
          await OpenFile.open(filePath);
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}


