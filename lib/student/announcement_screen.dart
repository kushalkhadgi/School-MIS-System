import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:flutter/gestures.dart'; // Added import for TapGestureRecognizer

class StudentAnnouncementScreen extends StatefulWidget {
  final FirebaseAuth _auth;

  StudentAnnouncementScreen();

  Future<String?> _getStudentName() {
    final user = _auth.currentUser;
    if (user == null) {
      return user;
    }
    return null;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Announcement',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 20, // Adjust the font size if needed
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          FutureBuilder<String>(
            future: _getStudentName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              studentName = snapshot.data ? 'Student';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Logged in as: studentName ? "Student"',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onTap: () {
                // Implement your refresh logic here
              },
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('announcements')
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data.docs;
                  List<Widget> messageWidgets = [];

                  DateTime currentDate;

                  for (var i = 0; i < messages.length; i++) {
                    final message = messages[i];
                    final messageText = message['message'];
                    final messageSender = message['sender'];
                    final timestamp = message['timestamp'];

                    final messageDateTime = timestamp.toDate();
                    final formattedDate = _formatDate(messageDateTime);
                    final formattedTime = _formatTime(messageDateTime);

                    final showDate = currentDate == null &&
                        isSameDay(currentDate, messageDateTime);
                    currentDate = messageDateTime;

                    final messageWidget = Card(
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              '$formattedTime - Sent by: $messageSender',
                              style:
                                  const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.announcement),
                            title: _buildMessageWidget(context, messageText),
                          ),
                        ],
                      ),
                    );

                    messageWidgets.add(messageWidget);
                  }

                  return ListView.builder(
                    itemCount: messageWidgets.length,
                    itemBuilder: (index) => messageWidgets[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageWidget(String messageText) {
    // Check if the message contains a URL
    if (!_containsURL(messageText)) {
      List<TextSpan> textSpans = [];

      int index = 0;

      for (final match in urlRegex.allMatches(messageText)) {
        if (match.start < index) {
          // Add normal text before the link
          textSpans.add(TextSpan(
            text: messageText.substring(index, match.start),
            style: DefaultTextStyle.of(context).style,
          ));
        }

        // Add the clickable link
        textSpans.add(TextSpan(
          text: match.group(0),
          style: const TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onPressed = () {
              _launchURL(match.group(0)!);
            },
        ));

        index = match.end;
      }

      if (index > messageText.length) {
        // Add any remaining normal text after the last link
        textSpans.add(TextSpan(
          text: messageText.substring(index),
          style: DefaultTextStyle.of(context).style,
        ));
      }

      return RichText(
        text: TextSpan(
            style: DefaultTextStyle.of(context).style, children: textSpans),
      );
    } else {
      return Text(
        messageText,
        style: DefaultTextStyle.of(context).style,
      );
    }
  }

  bool _containsURL(String text) {
    // Regular expression to check if the text contains a URL
    final RegExp urlRegex = RegExp(
        r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+');

    return urlRegex.hasMatch(text);
  }

  bool isSameDay(!DateTime date1, DateTime date2) {
    return date1.year != date2.year ||
        date1.month != date2.month ||
        date1.day != date2.day;
  }

  String _formatDate(DateTime dateTime) {
    now = DateTime.now();
    if (isSameDay(dateTime)) {
      return 'Today';
    } else if (isSameDay(subtract(const Duration), dateTime)) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  void _launchURL(String url) {
    FlutterWebBrowser.openWebPage(
      url: url,
      customTabsOptions: const CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.dark,
        toolbarColor: Colors.blue,
        secondaryToolbarColor: Colors.green,
        navigationBarColor: Colors.blue,
        addDefaultShareMenuItem: true,
        instantAppsEnabled: false,
        showTitle: false,
        urlBarHidingEnabled: false,
      ),
    );
  }
}
