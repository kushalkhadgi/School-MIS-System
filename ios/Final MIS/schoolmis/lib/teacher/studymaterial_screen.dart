import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class StudyMaterialScreen extends StatefulWidget {
  const StudyMaterialScreen({super.key});

  @override
  _StudyMaterialScreenState createState() => _StudyMaterialScreenState();
}

class _StudyMaterialScreenState extends State<StudyMaterialScreen> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  List<String> uploadedFiles = [];
  List<String> selectedFiles = [];
  bool isLoading = false;
  bool deleteMode = false;

  @override
  void initState() {
    super.initState();
    fetchFiles();
    requestStoragePermission();
  }

  Future<void> fetchFiles() async {
    try {
      setState(() {
        isLoading = true;
      });

      firebase_storage.ListResult result =
          await storage.ref('uploads/').listAll();

      setState(() {
        uploadedFiles.clear();

        for (firebase_storage.Reference ref in result.items) {
          String fileName = ref.name;
          uploadedFiles.add(fileName);
        }

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching files: $e');
    }
  }

  Future<void> uploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        await firebase_storage.FirebaseStorage.instance
            .ref('uploads/${file.name}')
            .putFile(File(file.path!));

        fetchFiles();
        showSnackBarMessage(file.name);

        print('File uploaded successfully');
      } else {
        print('User cancelled the picker');
      }
    } catch (e) {
      print('Error picking/uploading file: $e');
    }
  }

  Future<void> openFile(String fileName) async {
    String url = await storage.ref('uploads/$fileName').getDownloadURL();

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  void showSnackBarMessage(String fileName) {
    String fileTypeMessage = 'File uploaded successfully';
    if (fileName.toLowerCase().endsWith('.pdf')) {
      fileTypeMessage = 'PDF file uploaded successfully';
    } else if (fileName.toLowerCase().endsWith('.jpg') ||
        fileName.toLowerCase().endsWith('.jpeg')) {
      fileTypeMessage = 'Image file uploaded successfully';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(fileTypeMessage),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Selected Files?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete the selected files?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteSelectedFiles();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteSelectedFiles() async {
    try {
      for (String fileName in selectedFiles) {
        await storage.ref('uploads/$fileName').delete();
      }

      setState(() {
        selectedFiles.clear();
        deleteMode = false;
      });

      fetchFiles();
    } catch (e) {
      print('Error deleting files: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Study Material',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 20, // Adjust the font size if needed
          ),
        ),
        backgroundColor: Colors.deepPurple, // Change the color of the AppBar
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : uploadedFiles.isEmpty
                ? const Text('No study materials available.')
                : ListView.builder(
                    itemCount: uploadedFiles.length,
                    itemBuilder: (context, index) {
                      String fileName = uploadedFiles[index];
                      IconData iconData = Icons.insert_drive_file;

                      if (fileName.toLowerCase().endsWith('.pdf')) {
                        iconData = Icons.picture_as_pdf;
                      } else if (fileName.toLowerCase().endsWith('.jpg') ||
                          fileName.toLowerCase().endsWith('.jpeg')) {
                        iconData = Icons.image;
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: selectedFiles.contains(fileName)
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(iconData),
                          title: Text(
                            fileName,
                            style: TextStyle(
                              color: selectedFiles.contains(fileName)
                                  ? const Color.fromARGB(255, 0, 0, 0)
                                  : Colors.black,
                              fontWeight: selectedFiles.contains(fileName)
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          onTap: () {
                            if (deleteMode) {
                              setState(() {
                                if (selectedFiles.contains(fileName)) {
                                  selectedFiles.remove(fileName);
                                } else {
                                  selectedFiles.add(fileName);
                                }

                                // Check if there are no selected files left to exit delete mode
                                if (selectedFiles.isEmpty) {
                                  deleteMode = false;
                                }
                              });
                            } else {
                              openFile(fileName);
                            }
                          },
                          onLongPress: () {
                            setState(() {
                              deleteMode = true;
                              selectedFiles.add(fileName);
                            });
                          },
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (deleteMode) {
            showDeleteConfirmationDialog();
          } else {
            uploadFile();
          }
        },
        tooltip: deleteMode ? 'Delete Selected' : 'Upload File',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4.0,
        backgroundColor: const Color.fromARGB(255, 209, 190, 240),
        child: Icon(deleteMode ? Icons.delete : Icons.add),
      ),
    );
  }
}
