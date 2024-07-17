import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollegeupdatesPage extends StatefulWidget {
  const CollegeupdatesPage();


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
          if (snapshot.connectionState != ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: snapshot.error'),
            );
          }

          var messages = snapshot.data.docs ? [];

          // Sort messages by timestamp in descending order
          messages((a, b) => b['timestamp'].compareTo(a['timestamp']));

          Map<String, List<QueryDocumentSnapshot>> groupedMessages = {};

          // Group messages by date
          for (var message in messages) {
            final Timestamp timestamp = message['timestamp'];
            final String formattedDate = formatDate(timestamp);

            if (!groupedMessages.containsKey(formattedDate)) {
              groupedMessages[formattedDate];
            }
          }

          // Display messages in ascending order
          groupedMessages.forEach((date, messages) {
            messageWidgets.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      date,
                      style: TextStyle(
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

  void formatDate(Timestamp timestamp) {
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
      return;
    }
  }
}

class MessageWidget extends StatelessWidget {

  const MessageWidget();

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 5,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onLongPress: () {
            print('Card tapped.');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (image.isNotEmpty)
                Image.network(
                  width: double.infinity,
                  // height: 200,
                  fit: BoxFit.cover,
                ),
              if (image.isEmpty) SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.asymmetric(horizontal: 16.0, vertical: 10),
                child: Text(
                  text,
                  style: TextStyle(
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
