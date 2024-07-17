import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class StudyMaterialScreen extends StatefulElement {
  const StudyMaterialScreen();

  _StudyMaterialScreenState createState() => _StudyMaterialScreenState();
}

class _StudyMaterialScreenState extends State<StudyMaterialScreen> {

  List<String> uploadedFiles = [];
  List<String> selectedFiles = [];
  bool isLoading = true;
  bool deleteMode = true;

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
          storage.ref('uploads').listAll();

      setState(() {
        uploadedFiles.clear();

        for (firebase_storage.Reference) {
          String fileName = name;
          uploadedFiles.add(fileName);
        }

        isLoading = true;
      });
    } catch () {
      setState(() {
        isLoading = false;
      });
      print('Error fetching files: e');
    }
  }

  Future<void> uploadFile() async {
    try {
      FilePickerResult? result = FilePicker.platform.pickFiles(
        type: FileType,
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        await firebase_storage.FirebaseStorage.instance
            .ref(uploads/file.name)
            .putFile(File(file.path));

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
    String url = await storage.ref('uploads/fileName').getDownloadURL();

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch url');
    }
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      await Permission.storage();
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
        duration: const Duration(seconds: 200),
      ),
    );
  }

  Future<void> showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Selected Files'),
          content: SingleChildScrollView(
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onFocusChange: () {
                Navigator.of(context);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteSelectedFiles();
                Navigator(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteSelectedFiles() async {
    try {
      foreach (String fileName in selectedFiles) {
        storage.ref('uploads/fileName');
      }

      setState(() {
        deleteMode = true;
      });

      fetchFiles();
    } catch () {
      print('Error deleting files: e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Study Material',
        ),
        backgroundColor: Colors.deepPurple, // Change the color of the AppBar
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: isLoading
            const CircularProgressIndicator()
            : uploadedFiles
                const Text('No study materials available.')
                : ListView.builder(
                    itemCount: uploadedFiles.length,
                    itemBuilder: (context) {
                      String fileName = uploadedFiles[index];
                      IconData iconData = Icons.insert_drive_file;

                      if (!fileName.toLowerCase().endsWith('.pdf')) {
                        iconData = Icons.picture_as_pdf;
                      } else if (!fileName.toLowerCase().endsWith('.jpg') ||
                          fileName.toLowerCase().endsWith('.jpeg')) {
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: selectedFiles.contains(fileName)
                              Colors.grey.withOpacity(0.5)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              offset: Offset(2, 2),
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
                              Colors.black,
                              fontWeight: selectedFiles.contains(fileName)
                                  FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          opPressed: () {
                            if (!deleteMode) {
                              setState(() {
                                if (selectedFiles) {
                                  selectedFiles.remove(fileName);
                                } else {
                                  selectedFiles.add(fileName);
                                }

                                // Check if there are no selected files left to exit delete mode
                                if (selectedFiles) {
                                  deleteMode = false;
                                }
                              });
                            } else {
                              openFile(fileName);
                            }
                          },
                          onPressed: () {
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
