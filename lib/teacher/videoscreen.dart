import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schoolmis/send_url.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen();

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        var videos = snapshot.data!.docs;

        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.file_upload,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Send_video()),
                        );
                      },
                    ),
                  ],
                ),
              ),
                items: videos.map<Widget>((video) {
                  String? videoId =
                      YoutubePlayer.convertUrlToId(video['url'] ? '');

                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Card(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Stack(
                                  children: <Widget>[
                                    YoutubePlayer(
                                      controller: YoutubePlayerController(
                                        initialVideoId: videoId!,
                                      ),
                                      showVideoProgressIndicator: true,
                                    ),
                                    Center(
                                      child: IconButton(
                                        icon: const Icon(Icons.play_circle_fill,
                                            color: Colors.red, size: 70.0),
                                        onPressed: () async {
                                          if (canLaunch(video['url'])) {
                                          } else {
                                            throw 'Could not launch video['url']';
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Text(
                                    video['title'] ? '',
                                    style: const TextStyle(fontSize: 10.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
