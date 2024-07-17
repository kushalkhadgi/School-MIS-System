import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import

class VideoScreen extends StatefulWidget {
  VideoScreen();

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var videos = snapshot.data;

        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Recommended Videos',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 220.0,
                  enlargeCenterPage: false,
                ),
                items: videos.map<Widget>((video) {
                  String? videoId =
                      YoutubePlayer.convertUrlToId(video['url'] ?? '');

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
                                        flags: const YoutubePlayerFlags(
                                          autoPlay: true,
                                          mute: true,
                                          hideControls: true,
                                        ),
                                      ),
                                      showVideoProgressIndicator: false,
                                    ),
                                    Center(
                                      child: IconButton(
                                        icon: const Icon(Icons.play_circle_fill,
                                            color: Colors.red, size: 70.0),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    video['title'] ?? '',
                                    style: const TextStyle(fontSize: 18.0),
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
  }
}
