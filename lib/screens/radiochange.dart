import 'package:flutter/material.dart';
import 'package:prj_mobile/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prj_mobile/screens/radio.dart';

class ChangeStationForm extends StatefulWidget {
  @override
  _ChangeStationFormState createState() => _ChangeStationFormState();
}

class _ChangeStationFormState extends State<ChangeStationForm> {
  final AuthService _auth = AuthService();
  final FirebaseAuth _fbauth = FirebaseAuth.instance;
  String? _selectedStation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Station'),
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
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RadioApp()),
                );
              },
            ),
            ListTile(
              title: Text('Request a station Change'),
              tileColor: Colors.grey[300],
              onTap: () {},
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
      body: Center(
        child: DropdownButton<String>(
          value: _selectedStation,
          items: <String>[
            'Station A',
            'Station B',
            'Station C',
            'Station D',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedStation = newValue;
            });
          },
        ),
      ),
    );
  }
}
