import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadHomework extends StatefulWidget {
  const UploadHomework({super.key});

  @override
  _UploadHomeworkState createState() => _UploadHomeworkState();
}

class _UploadHomeworkState extends State<UploadHomework> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  List<String> uploadedFiles = [];
  List<String> selectedFiles = [];
  bool isLoading = false;
  bool deleteMode = false;
  String selectedClass = 'Class 1'; // Default selected class

  TextEditingController homeworkTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchFiles();
    requestStoragePermission();
  }

  Future<void> fetchFiles() async {
    // Implementation remains the same
  }

  Future<void> uploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        String textInput = homeworkTextController.text;

        // Save the text input and image to Firebase Storage
        await storage
            .ref('homework/$selectedClass/$textInput-${DateTime.now()}')
            .putFile(File(file.path!));

        fetchFiles();
        showSnackBarMessage('Homework uploaded successfully');

        print('Homework uploaded successfully');
      } else {
        print('User cancelled the picker');
      }
    } catch (e) {
      print('Error picking/uploading homework: $e');
    }
  }

  Future<void> requestStoragePermission() async {
    // Implementation remains the same
  }

  void showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> showDeleteConfirmationDialog() async {
    // Implementation remains the same
  }

  Future<void> deleteSelectedFiles() async {
    // Implementation remains the same
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Implementation remains the same
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : uploadedFiles.isEmpty
                ? const Text('No homework available.')
                : ListView.builder(
                    itemCount: uploadedFiles.length,
                    itemBuilder: (context, index) {
                      return null;
                    
                      // Implementation remains the same
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (deleteMode) {
            showDeleteConfirmationDialog();
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Add Homework'),
                  content: Column(
                    children: [
                      DropdownButton<String>(
                        value: selectedClass,
                        items: <String>[
                          'Class 1',
                          'Class 2',
                          'Class 3',
                          'Class 4',
                          'Class 5',
                          'Class 6',
                          'Class 7',
                          'Class 8',
                          'Class 9',
                          'Class 10',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedClass = newValue!;
                          });
                        },
                      ),
                      TextField(
                        controller: homeworkTextController,
                        decoration: const InputDecoration(labelText: 'Homework Text'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          uploadFile();
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Upload Image'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
        tooltip: deleteMode ? 'Delete Selected' : 'Add Homework',
        child: Icon(deleteMode ? Icons.delete : Icons.add),
      ),
    );
  }
}
