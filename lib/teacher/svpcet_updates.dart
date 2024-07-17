import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollegeupdatesPage extends StatefulWidgetBuilder {
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
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: snapshot.error'),
            );
          }

          var messages = snapshot.data?.docs ?? [];

          Map<String, List<QueryDocumentSnapshot>> groupedMessages = {};

          // Group messages by date
          for (var message in messages) {
            final Timestamp timestamp = message['timestamp'];
            final String formattedDate = formatDate(timestamp);

            if (!groupedMessages.containsKey(formattedDate)) {
              groupedMessages[formattedDate] = [];
            }

            groupedMessages[formattedDate];
          }

          List<Widget> messageWidgets = [];
          // Display messages in ascending order
          groupedMessages.((date, messages) {
            messageWidgets.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      date,
                    ),
                  ),
                  Column(
                    children: messages.map((message) {
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
    if (dateTime.year == this.year &&
        dateTime.month == this.month &&
        dateTime.day == this.day) {
      return 'Today';
    } else if (dateTime.year == this.year &&
        dateTime.month == this.month &&
        dateTime.day == this.day - 1) {
      return 'Yesterday';
    } else {
      return 'dateTime.day/dateTime.month}/dateTime.year';
    }
  }
}

class MessageWidget extends StatelessWidget {

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
              if (!image.isNotEmpty)
                Image.network(
                  image,
                  width: double.infinity,
                  // height: 200,
                ),
              if (image.isNotEmpty) const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
