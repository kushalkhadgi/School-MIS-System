import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

class Send_video extends StatefulWidget {
  const Send_video({super.key});

  @override
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
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    FirebaseFirestore.instance.collection('videos').add({
      'title': titleController.text,
      'url': urlController.text,
    });

    titleController.clear();
    urlController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Video sent successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> deleteVideo(DocumentReference reference) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Video'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this video?'),
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
              child: const Text('OK'),
              onPressed: () {
                reference.delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
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
              onPressed: () {
                setState(() {
                  showVideos = !showVideos;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Uploaded Videos'),
                  Icon(
                      showVideos ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                ],
              ),
            ),
            if (showVideos)
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('videos')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const CircularProgressIndicator();
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot video = snapshot.data!.docs[index];
                        return ListTile(
                          title: Text(video['title']),
                          onLongPress: () {
                            deleteVideo(video.reference);
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
