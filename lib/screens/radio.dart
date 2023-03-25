import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'package:prj_mobile/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prj_mobile/screens/radiochange.dart';

class Station {
  final String name;
  final String url;

  Station({required this.name, required this.url});
}

class RadioApp extends StatefulWidget {
  const RadioApp({Key? key}) : super(key: key);

  @override
  _RadioAppState createState() => _RadioAppState();
}

class _RadioAppState extends State<RadioApp> {
  final FirebaseAuth _fbauth = FirebaseAuth.instance;
  final AuthService _auth = AuthService();
  late AudioPlayer audioPlayer;
  double volumeValue = 0.5;
  bool isPlaying = false;
  bool isLoading = false;
  Station? currentStation;
  List<Station> stations = [
    Station(
        name: "Mosaique",
        url: "https://radio.mosaiquefm.net/mosalive?1677329762270"),
    Station(
        name: "Zitouna",
        url:
            "https://stream.radiozitouna.tn/radio/8030/radio.mp3?1679503778784"),
    Station(
        name: "IFM",
        url: "https://live.ifm.tn/radio/8000/ifmlive?1585267848&1677330133113"),
    Station(
        name: "Express",
        url:
            "https://expressfm.ice.infomaniak.ch/expressfm-64.mp3?1677330200699"),
    Station(
        name: "Diwan",
        url: "https://streaming.diwanfm.net/stream?1677330272092"),
  ];
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.setVolume(volumeValue);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

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
        isLoading = false; // set isLoading to false to hide the spinner
      });
    });
  }

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

  void _setVolume(double value) {
    setState(() {
      volumeValue = value;
      audioPlayer.setVolume(volumeValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text("RadioHubTN"),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: AssetImage('assets/rad.png'),
                    backgroundColor: Colors.transparent,
                  ),
                  Text(
                    "Welcome" +
                        " " +
                        _fbauth.currentUser!.email!.substring(
                            0, _fbauth.currentUser!.email!.indexOf("@")),
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Browse Stations'),
              tileColor: Colors.grey[300],
              onTap: () {},
            ),
            ListTile(
              title: Text('Request a station Change'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangeStationForm()),
                );
              },
            ),
            ListTile(
              title: Text('Sign Out'),
              onTap: () async {
                await _auth.signout();
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
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
