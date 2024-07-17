import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ClassTestPage(),
    );
  }
}

class ClassTestPage extends StatefulWidget {
  const ClassTestPage({super.key});

  @override
  _ClassTestPageState createState() => _ClassTestPageState();
}

class _ClassTestPageState extends State<ClassTestPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? selectedClass;
  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> questions = [];
  TextEditingController questionController = TextEditingController();
  TextEditingController option1Controller = TextEditingController();
  TextEditingController option2Controller = TextEditingController();
  TextEditingController option3Controller = TextEditingController();
  TextEditingController option4Controller = TextEditingController();
  String? correctOption;
  File? _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Test'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: selectedClass,
              onChanged: (value) {
                setState(() {
                  selectedClass = value;
                });
                fetchStudents(selectedClass!);
              },
              items: ["Class 1", "Class 2", "Class 3"] // Add your class options here
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            if (students.isNotEmpty)
              Column(
                children: students
                    .map((student) => ListTile(
                          title: Text(student['name']), // assuming 'name' is a field in your student data
                          // Add more fields if needed
                        ))
                    .toList(),
              ),
            if (students.isEmpty && selectedClass != null)
              Center(
                child: Text(
                  'No students available for $selectedClass',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Question for Quiz:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: questionController,
                    decoration: const InputDecoration(labelText: 'Question'),
                  ),
                  ElevatedButton(
                    onPressed: getImage,
                    child: const Text('Select Image'),
                  ),
                  _image != null
                      ? Image.file(_image!)
                      : const SizedBox(), // Display selected image if available
                  TextField(
                    controller: option1Controller,
                    decoration: const InputDecoration(labelText: 'Option 1'),
                  ),
                  TextField(
                    controller: option2Controller,
                    decoration: const InputDecoration(labelText: 'Option 2'),
                  ),
                  TextField(
                    controller: option3Controller,
                    decoration: const InputDecoration(labelText: 'Option 3'),
                  ),
                  TextField(
                    controller: option4Controller,
                    decoration: const InputDecoration(labelText: 'Option 4'),
                  ),
                  DropdownButtonFormField<String>(
                    value: correctOption,
                    onChanged: (value) {
                      setState(() {
                        correctOption = value;
                      });
                    },
                    items: ["Option 1", "Option 2", "Option 3", "Option 4"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(labelText: 'Select Correct Option'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Upload the test
                        },
                        child: const Text('Upload Test'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _addQuestion();
                        },
                        child: const Text('Add Next Question'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _addQuestion() {
    Map<String, dynamic> question = {
      'question': questionController.text,
      'option1': option1Controller.text,
      'option2': option2Controller.text,
      'option3': option3Controller.text,
      'option4': option4Controller.text,
      'correctOption': correctOption,
    };
    setState(() {
      questions.add(question);
    });
    _clearQuestionFields();
  }

  void _clearQuestionFields() {
    questionController.clear();
    option1Controller.clear();
    option2Controller.clear();
    option3Controller.clear();
    option4Controller.clear();
    correctOption = null;
  }

  void fetchStudents(String grade) async {
    try {
      final querySnapshot = await firestore
          .collection('students')
          .where('grade', isEqualTo: grade)
          .get();
      setState(() {
        students = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print('Error fetching students: $e');
    }
  }
}


