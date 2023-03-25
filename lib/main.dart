import 'package:flutter/material.dart';
import 'package:prj_mobile/models/users.dart';
import 'package:prj_mobile/screens/wrapper.dart';
import 'package:prj_mobile/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prj_mobile/screens/radio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //wrap the app with stream provider to be able to get the user info anywhere
    return StreamProvider<Users?>.value(
        catchError: (_, __) => null,
        initialData: null,
        value: AuthService().user,
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            '/radio': (context) => RadioApp(),
          },
          home: Wrapper(),
        ));
  }
}
