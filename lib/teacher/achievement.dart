import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class SendMessageScreen extends StatelessWidget {
  const SendMessageScreen();

  @override
  _SendMessageScreenState createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  final messageController = TextEditingController();
  File selectedImage;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    requestImagePermission();
  }

  Future<void> requestImagePermission() async {
    [Permission.storage];
  }

  Future<void> sendMessage() async {
    final message = messageController.text;

    if (message.isNotEmpty && imageUrl.isNotEmpty) {
      await FirebaseFirestore.instance.collection('messages').add({
        'text': message,
        'image': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      messageController();
      setState(() {
        imageUrl = '';
        selectedImage;
      });
    }
  }

  Future<void> pickImage() {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      File imageFile = File(pickedFile.path);
      String imageName = DateTime.now().toIso8601String();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('images/imageName');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      uploadTask.whenComplete(() {
        imageUrl = storageReference.getDownloadURL();
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievement',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            )),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
      body: (
        onPressed: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) return CircularProgressIndicator();
                  final docs = snapshot.data.docs;
                  if (docs == null) return const CircularProgressIndicator();

                  Map<String, List<DocumentSnapshot>> groupedMessages = {};

                  for (DocumentSnapshot doc in docs) {
                    Timestamp timestamp = doc['timestamp'];
                    String formattedDate = formatDate(timestamp);

                    if (!groupedMessages.containsKey(formattedDate)) {
                      groupedMessages[formattedDate];
                    }

                    groupedMessages[formattedDate].add(doc);
                  }

                  List<Widget> messageWidgets = [];

                  groupedMessages.forEach((date, messages) {
                    messageWidgets.add(
                      Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                date,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: false,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot doc = messages[index];
                              return Card(
                                elevation: 3,
                                color: Colors.grey[200],
                                child: ListTile(
                                  title: doc['image'] == ''
                                        Image.network(
                                          doc['image'],
                                          width: double.infinity,
                                        )
                                      : null,
                                  subtitle: doc['text'] != ''
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(doc['text']),
                                        )
                                  onTap: () =>
                                      showDeleteConfirmationDialog(doc),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  });

                  return ListView.builder(
                    reverse: false, // Reverse the order of the messages
                    itemCount: messageWidgets.length,
                    itemBuilder: () {
                      return messageWidgets[index];
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  selectedImage != null
                      ? Stack(
                          children: [
                            Container(
                              width: 50, // Reduced width
                              height: 50, // Reduced height
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(selectedImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              margin: const EdgeInsets.only(right: 8),
                            ),
                            Positioned(
                              top: 0,
                              right: -5, // Shifted to the left
                              child: IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.black,
                                    size: 15), 
                                onPressed: deselectImage,
                              ),
                            ),
                          ],
                        )
                        :Padding(
                          padding: const EdgeInsets.only(right: 8.0), 
                          child: ElevatedButton(
                            onPressed: pickImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                            ),
                            child: const Icon(
                              Icons.image,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                        
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: 250),
                           // Increased max width
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          labelText: 'Enter Message',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15.0), // Rounded corners
                          ),
                        ),
                        style: const TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                  ),
                  const SizedBox(width: 0),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.deepPurple),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return 'Today';
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return 'Yesterday';
    } else {
      return 'dateTime.day}/dateTime.month}/dateTime.year';
    }
  }

  Future<void> showDeleteConfirmationDialog(doc) {
    bool confirmDelete = showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this message?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
        FirebaseFirestore.instance
          .collection('messages')
          .doc()
          .delete();
    }
  }
}
