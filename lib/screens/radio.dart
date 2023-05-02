import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'package:prj_mobile/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';

class Station {
  final String name;
  final String url; //the url used for audio streaming
  final String video; //the url used for video streaming
  final String logo; //the radio logo link

  Station(
      {required this.name,
      required this.url,
      required this.video,
      required this.logo});
}

class RadioApp extends StatefulWidget {
  const RadioApp({Key? key}) : super(key: key);

  @override
  _RadioAppState createState() => _RadioAppState();
}

class _RadioAppState extends State<RadioApp> {
  final AuthService _auth = AuthService();

  late AudioPlayer audioPlayer; //responsable for playing the audio streaming
  double volumeValue = 0.5;
  bool isPlaying = false; //check if there is a station playing
  bool isLoading = false; //check if there is a station loading
  Station? currentStation; //the station playing at the moment
  bool dbloading = true; //check if the data is still loading from the DB

  List<Station> stations = [];

  //initilizing the audio player and volume and retreiving the stations from DB
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.setVolume(volumeValue);
    getdata();
  }

//method responsable for getting the stations from firebase
  void getdata() async {
    final FirebaseFirestore fs = FirebaseFirestore.instance;
    final CollectionReference stationsCollection = fs.collection('stations');
    final QuerySnapshot stationsSnapshot = await stationsCollection.get();
    final List<Station> stationss = [];

    stationsSnapshot.docs.forEach((doc) {
      final String name = doc.id;
      final String url = doc.get('url');
      final String video = doc.get('video');
      final String logo = doc.get('logo');

      final Station station =
          Station(name: name, url: url, video: video, logo: logo);
      stationss.add(station);
    });
    setState(() {
      stations = stationss;
      dbloading = false;
    });
  }

  //function fired when a station is selected which loads and plays the selected station
  void _play(Station station) async {
    if (audioPlayer.playing) {
      await audioPlayer.stop();
    }
    setState(() {
      isLoading = true;
      isPlaying = true;
    });
    audioPlayer.setUrl(station.url);
    audioPlayer.play();
    setState(() {
      currentStation = station;
    });
    Timer(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  //function used to turn off any station playing
  void _turnOff() async {
    if (audioPlayer.playing) {
      await audioPlayer.stop();
      setState(() {
        currentStation = null;
      });
    }
    setState(() {
      isPlaying = false;
    });
  }

  //function used to change the volume of the currently playing station
  void _setVolume(double value) {
    setState(() {
      volumeValue = value;
      audioPlayer.setVolume(volumeValue);
    });
  }

  //function used to open video streaming for a specific station that creates a window playing the youtube stream
  void _openVideo(Station station) {
    if (station.video.isEmpty) {
      return;
    }
    _setVolume(0.5);
    _turnOff();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Stack(
            children: [
              YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: YoutubePlayer.convertUrlToId(station.video)!,
                  flags: YoutubePlayerFlags(
                    autoPlay: true,
                    mute: false,
                    isLive: false,
                    enableCaption: false,
                    controlsVisibleAtStart: true,
                  ),
                ),
                showVideoProgressIndicator: true,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    SystemChrome.setEnabledSystemUIOverlays(
                        SystemUiOverlay.values);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool test = dbloading || isLoading;
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: const Text("RadioHubTN"),
        //button for the user to logout
        actions: [
          TextButton.icon(
            onPressed: () async {
              await _auth.signout();
            },
            icon: Icon(Icons.logout, color: Colors.white),
            label: Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
        backgroundColor: Colors.blueGrey[800],
      ),
      //check if the page is loading if so display the loading spinner
      body: test
          ? Center(
              child: CircularProgressIndicator(),
            )
          //display the currently playing station's logo as background pic
          : Container(
              decoration: BoxDecoration(
                image: currentStation != null
                    ? DecorationImage(
                        opacity: 0.1,
                        image: NetworkImage(
                          currentStation!.logo,
                        ),
                        fit: BoxFit.contain,
                      )
                    : null,
              ),
              //display all the stations
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Choose one of the stations by tapping it or tap the video icon for a station to watch it's live stream",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: stations.length,
                      itemBuilder: (BuildContext context, int index) {
                        Station station = stations[index];
                        return Column(
                          children: [
                            ListTile(
                                leading: Image.network(
                                  station.logo,
                                  width: 50,
                                  height: 50,
                                ),
                                title: Text(
                                  station.name,
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: InkWell(
                                  onTap: () {
                                    // execute something when the video icon is tapped
                                    _openVideo(station);
                                  },
                                  child: Tooltip(
                                    message: 'Live Video Stream',
                                    child: station.video != ""
                                        ? Icon(
                                            Icons.videocam,
                                            color: Colors.white,
                                            size: 30,
                                          )
                                        : null,
                                  ),
                                ),
                                tileColor:
                                    isPlaying && currentStation == station
                                        ? Colors.blueGrey[800]
                                        : null,
                                onTap: () => {
                                      _play(station),
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(station.name +
                                                " " +
                                                "played successfully!")),
                                      )
                                    }),
                            Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                  const Text(
                    "Volume Level",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  //option to change the volume
                  Slider(
                    value: volumeValue,
                    onChanged: (double value) => _setVolume(value),
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: 'Volume',
                  ),
                  //option to to turn off the stations
                  ElevatedButton(
                    child: Text("Turn Off Stations"),
                    onPressed: () {
                      _turnOff();
                      currentStation != null
                          ? ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(currentStation!.name +
                                      " " +
                                      "stopped successfully!")),
                            )
                          : null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
    );
  }
}
