import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

class Send_video extends StatefulWidget {
  const Send_video();

  _Send_videoState createState() => _Send_videoState();
}

class _Send_videoState extends State<Send_video> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  bool showVideos = false;

  void sendVideo(BuildContext context) {
    if (titleController.text.isEmpty || urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both title and URL'),
          duration: Duration(seconds: 2000),
        ),
      );
      return;
    }

    FirebaseFirestore.instance.collection('videos').add({
      'title': titleController.text,
      'url': urlController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Video sent successfully'),
        duration: Duration(seconds: 2000),
      ),
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload Video',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 10,
              shadowColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Video Title'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: urlController,
                      decoration:
                          const InputDecoration(labelText: 'YouTube Video URL'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => sendVideo(context),
                      child: const Text('Send Video'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Uploaded Videos'),
                ],
              ),
            ),
            if (!showVideos)
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('videos')
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: () {
                        DocumentSnapshot video = snapshot.data!.docs[index];
                        return ListTile(
                          onLongPress: () {
                            deleteVideo();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
