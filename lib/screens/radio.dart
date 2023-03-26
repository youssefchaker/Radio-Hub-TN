import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'package:prj_mobile/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';

class Station {
  final String name;
  final String url;//the url used for audio streaming
  final String video;//the url used for video streaming

  Station({required this.name, required this.url, required this.video});
}

class RadioApp extends StatefulWidget {
  const RadioApp({Key? key}) : super(key: key);

  @override
  _RadioAppState createState() => _RadioAppState();
}

class _RadioAppState extends State<RadioApp> {
  final AuthService _auth = AuthService();

  late AudioPlayer audioPlayer;//responsable for playing the audio streaming 
  double volumeValue = 0.5;
  bool isPlaying = false;//check if there is a station playing 
  bool isLoading = false;//check if there is a station loading
  Station? currentStation;//the station playing at the moment

  List<Station> stations = [
    Station(
        name: "Mosaique",
        url: "https://radio.mosaiquefm.net/mosalive?1677329762270",
        video: ""),
    Station(
        name: "Zitouna",
        url:
            "https://stream.radiozitouna.tn/radio/8030/radio.mp3?1679503778784",
        video: ""),
    Station(
        name: "IFM",
        url: "https://live.ifm.tn/radio/8000/ifmlive?1585267848&1677330133113",
        video: "https://www.youtube.com/watch?v=jWIt5lucbd8&ab_channel=IFM"),
    Station(
        name: "Express",
        url:
            "https://expressfm.ice.infomaniak.ch/expressfm-64.mp3?1677330200699",
        video:
            "https://www.youtube.com/watch?v=OCNREw67M4c&ab_channel=RadioExpressFM"),
    Station(
        name: "Diwan",
        url: "https://streaming.diwanfm.net/stream?1677330272092",
        video: ""),
  ];

  //initilizing the audio player and volume
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.setVolume(volumeValue);
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
    return Scaffold(
      backgroundColor: Colors.grey,
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
        backgroundColor: Colors.blue,
      ),
      //check if the page is loading if so display the loading spinner
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
            //display the currently playing station's logo as background pic
          : Container(
              decoration: BoxDecoration(
                image: currentStation != null
                    ? DecorationImage(
                        opacity: 0.1,
                        image: AssetImage(
                          'assets/logos/${currentStation!.name.toLowerCase()}.png',
                        ),
                        fit: BoxFit.contain,
                      )
                    : null,
              ),
              //display all the stations
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: stations.length,
                      itemBuilder: (BuildContext context, int index) {
                        Station station = stations[index];
                        return Column(
                          children: [
                            ListTile(
                                leading: Image.asset(
                                  'assets/logos/${station.name.toLowerCase()}.png',
                                  width: 50,
                                  height: 50,
                                ),
                                title: Text(station.name),
                                trailing: InkWell(
                                  onTap: () {
                                    // execute something when the video icon is tapped
                                    _openVideo(station);
                                  },
                                  child: Tooltip(
                                    message: 'Live Video Stream',
                                    child: station.video != ""
                                        ? Icon(Icons.videocam)
                                        : null,
                                  ),
                                ),
                                tileColor:
                                    isPlaying && currentStation == station
                                        ? Colors.grey[300]
                                        : null,
                                onTap: () => {_play(station)}),
                            Divider(),
                          ],
                        );
                      },
                    ),
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
                  SizedBox(
                    height: 20,
                  ),
                  //option to to turn off the stations
                  ElevatedButton(
                    child: Text("Turn Off"),
                    onPressed: () => _turnOff(),
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
