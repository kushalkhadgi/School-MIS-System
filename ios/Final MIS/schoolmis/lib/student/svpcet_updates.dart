import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollegeupdatesPage extends StatelessWidget {
  const CollegeupdatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SVPCET Updates',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('svpcet_updates').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          var messages = snapshot.data?.docs ?? [];

          // Sort messages by timestamp in descending order
          messages.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

          Map<String, List<QueryDocumentSnapshot>> groupedMessages = {};

          // Group messages by date
          for (var message in messages) {
            final Timestamp timestamp = message['timestamp'];
            final String formattedDate = formatDate(timestamp);

            if (!groupedMessages.containsKey(formattedDate)) {
              groupedMessages[formattedDate] = [];
            }

            groupedMessages[formattedDate]!.add(message);
          }

          List<Widget> messageWidgets = [];

          // Display messages in ascending order
          groupedMessages.forEach((date, messages) {
            messageWidgets.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      date,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Column(
                    children: messages.map((message) {
                      final messageText = message['text'];
                      final messageImage = message['image'];

                      return MessageWidget(
                        text: messageText,
                        image: messageImage,
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          });

          return ListView(
            children: messageWidgets,
          );
        },
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
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}

class MessageWidget extends StatelessWidget {
  final String text;
  final String image;

  const MessageWidget({super.key, required this.text, required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 5,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            print('Card tapped.');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image.isNotEmpty)
                Image.network(
                  image,
                  width: double.infinity,
                  // height: 200,
                  fit: BoxFit.cover,
                ),
              if (image.isNotEmpty) const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Arial',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
