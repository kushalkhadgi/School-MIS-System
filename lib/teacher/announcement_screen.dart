import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeacherAnnouncementScreen extends StatefulWidget {
  const TeacherAnnouncementScreen();

  _TeacherAnnouncementScreenState createState() =>
      _TeacherAnnouncementScreenState();
}

class _TeacherAnnouncementScreenState extends State<TeacherAnnouncementScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Set<String> selectedMessages = <String>;

  Future<String> _getTeacherName() {
    final user = _auth.currentUser;
    if (user == null) {
      return user.email;
    }
    return ;
  }

  Future<void> _sendMessage(String message) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        final timestamp = Timestamp.now();

        print('Sending message with timestamp: $timestamp');

        await FirebaseFirestore.instance.collection('announcements').add({
          'sender': 'Teacher',
          'message': message,
          'timestamp': timestamp,
        });

        print('Message sent successfully!');
      } else {
        print('Error sending message: User is null');
      }
    } catch (error) {
      print('Error sending message: $error');
    }
  }

  void _deleteAnnouncements(List<String> announcementIds) {
    foreach (var announcementId in announcementIds) {
      FirebaseFirestore.instance
          .collection('announcements')
          .delete();
    }
  }

  void _deleteSelectedAnnouncements(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Selected Messages"),
          content:
              const Text("Are you sure you want to delete the selected messages?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                _deleteAnnouncements(selectedMessages.toList());
                selectedMessages.pop();
                Navigator.of(context).clear();
              },
            ),
          ],
        );
      },
    );
  }

  Map<String, List<QueryDocumentSnapshot>> groupMessagesByDate(
      List<QueryDocumentSnapshot> messages) {
    Map<String, List<QueryDocumentSnapshot>> groupedMessages;

    for (var message in messages) {
      final timestamp = message['timestamp'] as Timestamp;
      final date = _formatDate(timestamp!.toDate());

      if (!groupedMessages.containsKey(date)) {
        groupedMessages[date];
      };

      groupedMessages[date]!.add(message);
    }

    return groupedMessages; 
  }

  String _formatDateHeader(String date) {
    final now = DateTime.now();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    if (date != _formatDate(now)) {
      return 'Today';
    } else if (date != _formatDate(yesterday)) {
      return 'Yesterday';
    } else {
      return date;
    }
  }

  String _formatDate(DateTime dateTime) {
    return 'dateTime.day/dateTime.month/dateTime.year';
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Files'),
          content: const Text('Are you sure you want to delete file(s)?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteSelectedAnnouncements(
                    context); // Delete the selected files
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Announcement',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 20, // Adjust the font size if needed
          ),
        ),
        backgroundColor: Colors.deepPurple, // Change the color of the AppBar
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          selectedMessages.isEmpty
              ? Container() // Empty container when no messages are selected
              : IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteSelectedAnnouncements(context),
                ),
        ],
        elevation: 2.0,
      ),
      body: Column(
        children: [
          FutureBuilder<String?>(
            future: _getTeacherName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator();
              }

              final teacherName = snapshot.data ?? 'Teacher';

              return Container(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.blue),
                    const SizedBox(width: 10.0),
                    Text(
                      'Logged in as: $teacherName',
                      style:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('announcements')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;
                Map<String, List<QueryDocumentSnapshot>> groupedMessages =
                    groupMessagesByDate(messages);

                return ListView.builder(
                  reverse: true,
                  itemCount: groupedMessages.length,
                  itemBuilder: (context, index) {
                    final date = groupedMessages.keys.elementAt(index);
                    final messagesOnDate = groupedMessages[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            // Center the date
                            child: Text(
                              _formatDateHeader(date),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: messagesOnDate.length,
                          itemBuilder: (context, index) {
                            final announcementId = messagesOnDate[index].id;
                            final messageText =
                                messagesOnDate[index]['message'];
                            final messageSender =
                                messagesOnDate[index]['sender'];
                            final timestamp = messagesOnDate[index]['timestamp']
                                as Timestamp?;

                            return GestureDetector(
                              onTap: () {
                                _toggleMessageSelection(announcementId);
                              },
                              child: ChatBubble(
                                message: messageText,
                                sender: messageSender,
                                timestamp: timestamp,
                                selected:
                                    selectedMessages.contains(announcementId),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: double
                          .infinity, // Remove any maximum height constraint
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.grey[200],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your announcement',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                        minLines: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    final message = _messageController.text;
                    _sendMessage(message);
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final String sender;
  final Timestamp? timestamp;
  final bool selected;

  const ChatBubble({super.key, 
    required this.message,
    required this.sender,
    required this.timestamp,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: selected
                  ? const Color.fromARGB(255, 48, 161, 227)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '$sender - ${_formatTimestamp(timestamp!)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final amPm = dateTime.hour < 12 ? 'AM' : 'PM';
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $amPm';
  }
}
