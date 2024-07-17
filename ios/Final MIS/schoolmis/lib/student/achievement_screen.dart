import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FetchMessageScreen extends StatelessWidget {
  const FetchMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Achivement',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 20, // Adjust the font size if needed
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('messages').snapshots(),
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

          Map<String, List<QueryDocumentSnapshot>> groupedMessages = {};

          for (var message in messages) {
            final Timestamp timestamp = message['timestamp'];
            final String formattedDate = formatDate(timestamp);

            if (!groupedMessages.containsKey(formattedDate)) {
              groupedMessages[formattedDate] = [];
            }

            groupedMessages[formattedDate]!.add(message);
          }

          List<Widget> messageWidgets = [];

          // Display Today and Yesterday messages first
          for (var date in ['Today', 'Yesterday']) {
            if (groupedMessages.containsKey(date)) {
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
                          fontSize: 15, // Adjust the font size
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: groupedMessages[date]!.length,
                      itemBuilder: (context, index) {
                        var message = groupedMessages[date]![index];
                        final messageText = message['text'];
                        final messageImage = message['image'];

                        final messageWidget = MessageWidget(
                          text: messageText,
                          image: messageImage,
                        );

                        return messageWidget;
                      },
                    ),
                  ],
                ),
              );
            }
          }

          // Display other dates in ascending order
          groupedMessages.forEach((date, messages) {
            if (date != 'Today' && date != 'Yesterday') {
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
                          fontSize: 15, // Adjust the font size
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
            }
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
              if (image.isNotEmpty) Image.network(image),
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
